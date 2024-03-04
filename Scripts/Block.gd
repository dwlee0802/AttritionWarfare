extends Control
class_name Block

@onready var detectionArea: Area2D = $GroundTexture/SurfaceTexture/DetectionArea/Area2D

var centerPosition

@export var ignoreCombatWidth: bool = false
var curCombatWidth: int = 0
var maxCombatWidth: int = 1
var tempCombatWidth: int = 0

@onready var contentsLabel: RichTextLabel = $GroundTexture/SideTexture/ContentsLabel

var insideUnits = []

var nextBlock: Block
var prevBlock: Block

@onready var debugLabel: Label = $DebugLabel

@onready var slotContainer = $GroundTexture/SurfaceTexture/SlotContainer
var slotScene = load("res://Scenes/block_slot.tscn")
var slots = []

# industry stuff
# maybe redundant? just keep track of industry block and not industry
# unparent it from deck/editor when it is lost. could be better for performance too.
@export var industry: Industry = null
# when capture state changes from !player to player, add an IB to deck
# when it changes from player to !player, remove the IB
var industryBlock: IndustryBlock = null

@onready var captureStatusTexture : ColorRect = $CaptureStatus
var captureState: Enums.BlockState = Enums.BlockState.Neutral

@onready var buildButton = $CaptureStatus/IndustryIcons/BuildButton

# assume only one industry per block and two infrastructure
@onready var infraIcon1 = $CaptureStatus/IndustryIcons/InfraIcon
@onready var infraIcon2 = $CaptureStatus/IndustryIcons/InfraIcon2
@onready var industryIcon = $CaptureStatus/IndustryIcons/IndustryIcon
@onready var tempIndustryLabel = $CaptureStatus/IndustryIcons/IndustryIcon/TempIndustryLabel

@onready var buildOptions = $CaptureStatus/IndustryIcons/BuildButton/BuildOptions

@onready var sellButton = $CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Industry/SellButton

@onready var industryButtons = $CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Industry
@onready var infraButtons = $CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Industry

@onready var industryIcons = $CaptureStatus/IndustryIcons

# temporary testing values
var canBuildCoal: bool = false
var canBuildIron: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Industry/SellButton.pressed.connect(SellButtonPressed)
	maxCombatWidth = randi_range(1, 9)
	CheckIfCapital()
	
	for i in range(maxCombatWidth):
		var newSlot = slotScene.instantiate()
		slots.append(newSlot)
		slotContainer.add_child(newSlot)
		
	ConnectBuildSignals()
	UpdateOptionButtons()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	centerPosition = detectionArea.global_position.x
	insideUnits = GetUnitsInside()
	UpdateContentsLabel()
	debugLabel.text = str(global_position)
	
	if curCombatWidth < 0:
		curCombatWidth = 0
	
	UpdateCaptureStatus()
	UpdateIndustryIcon()
	
	
	# need to disable other build buttons when one is pressed
	var pressedButton = buildButton.button_group.get_pressed_button()
	if pressedButton != null:
		if pressedButton != buildButton:
			buildButton.visible = false
		else:
			buildButton.visible = true
	else:
		if ConstructionTab.isBuildMode and captureState == Enums.BlockState.Player:
			buildButton.visible = true
		else:
			buildButton.visible = false
			

func UpdateContentsLabel():
	var output = ""
	
	# count units on this block for each type
	var countDict = {}
	
	for unit in insideUnits:
		if unit is Unit:
			if countDict.has(unit.unitData.unitType):
				countDict[unit.unitData.unitType] += 1
			else:
				countDict[unit.unitData.unitType] = 1
	
	for key in countDict.keys():
		output += "[fill]" + Enums.UnitTypeToAbbString(key) + ": " + str(countDict[key]) + "[/fill]\n"
	
	if !ignoreCombatWidth:
		output += "[fill]Total: "+ str(curCombatWidth) + "/" + str(maxCombatWidth) + "[/fill]\n"
	
	contentsLabel.text = output
	

# units are considered 'on' this block only if their position is equal or greater than self's width
# specifically, unit's position should be inside [self.global_position, self.global_position + size.x)
func GetUnitsInside(player: bool = true):
	var results = detectionArea.get_overlapping_bodies()
	var output = []
	for unit in results:
		if unit is Unit:
			if unit.global_position.x > global_position.x and unit.global_position.x < global_position.x + size.x:
				if unit.isPlayerUnit == player:
					output.append(unit)
	
	return output


func CheckIfCapital():
	var results = detectionArea.get_overlapping_bodies()
	for unit in results:
		if unit is HQ:
			ignoreCombatWidth = true
			unit.currentBlock = self


func isFull() -> bool:
	if curCombatWidth < maxCombatWidth:
		return false
	else:
		return true


# tells the caller if there is enough space in self
# should be only called once per unit
func GivePermission():
	if ignoreCombatWidth:
		return true
		
	if curCombatWidth + 1 <= maxCombatWidth:
		curCombatWidth += 1
		return true
	else:
		return false
		

# return the one that is closest to pos
func GetEmptySlot(pos: Vector2):
	var output: BlockSlot = null
	var smallestDist = 0
	for slot: BlockSlot in slots:
		if !slot.isOccupied:
			if output == null:
				output = slot
				smallestDist = slot.GetCenterPosition().distance_to(pos)
			else:
				# check dist
				var newDist = slot.GetCenterPosition().distance_to(pos)
				if smallestDist > newDist:
					smallestDist = newDist
					output = slot
	
	if output != null:
		output.isOccupied = true
		return output
	else:
		return null


# could optimize this further
# or only call it when necessary
# future plan: change the capture color according to faction
func UpdateCaptureStatus():
	var playerUnits = GetUnitsInside()
	var enemyUnits = GetUnitsInside(false)
	
	if len(playerUnits) > 0:
		if industry != null:
			if captureState != Enums.BlockState.Player:
				# this block was newly captured by player
				# make IB and add it to deck
				industryBlock = IndustryEditor.instance.AddIndustryBlock(industry)
			
		captureStatusTexture.self_modulate = Color.DEEP_SKY_BLUE
		captureState = Enums.BlockState.Player
	elif len(enemyUnits) > 0:
		if captureState != Enums.BlockState.Enemy:
			# this block was just lost from player
			# remove self's IB from deck or editor
			if industryBlock != null:
				if industryBlock.get_parent() is IndustrySlot:
					industryBlock.get_parent().RemoveBonus()
				
				industryBlock.queue_free()
			
		captureStatusTexture.self_modulate = Color.DARK_RED
		captureState = Enums.BlockState.Enemy
			

func UpdateIndustryIcon():
	if industry != null:
		industryIcon.visible = true
		var output = ""
		output += "Lv: " + str(industry.level)
		output += Enums.GoodTypeToIndustryName(industry.productionType)
		tempIndustryLabel.text = output
	else:
		industryIcon.visible = false


# show sell button and level up button if industry exists
# otherwise show options and their costs
func UpdateOptionButtons():
	if industry == null:
		sellButton.visible = false
		for child in buildOptions.get_node("Industry").get_children():
			if child is BuildTypeButton:
				if child.goodType == Enums.GoodType.Coal and canBuildCoal == false:
					child.visible = false
					continue
				if child.goodType == Enums.GoodType.Iron and canBuildIron == false:
					child.visible = false
					continue
					
				var cost = load(Enums.GoodTypeToDataPath(child.goodType)).levelUpCost
				child.visible = true
				child.cost = cost
				child.text = Enums.GoodTypeToIndustryName(child.goodType) + " (" + str(cost) + ")"
	else:
		for child in buildOptions.get_node("Industry").get_children():
			if child is BuildTypeButton:
				child.visible = false
				if child.goodType == industry.productionType:
					child.visible = true
					child.text = "Level up " + " (" + str(industry.levelUpCost * (industry.level + 1)) + ")"
					child.cost = industry.levelUpCost * (industry.level + 1)
		sellButton.visible = true
		sellButton.text = "Sell (" + str(industry.levelUpCost * 0.8) + ")"
		

func BuildIndustry(type: Enums.GoodType):
	# need to remove industry first to build new one!
	if industry != null:
		if industry.productionType != type:
			print("ERROR! Trying to build new industry in already occupied Block.")
			return
		else:
			industry.level += 1
			print("Increased level.")
			UpdateOptionButtons()
			industryIcons.Reset()
			return
	
	industry = Industry.new(load(Enums.GoodTypeToDataPath(type)))
	add_child(industry)
	industryBlock = IndustryEditor.instance.AddIndustryBlock(industry)
	
	Game.playerNation.ChangeFunds(-500)
	industryIcons.Reset()
	
	print("Built new " + Enums.GoodTypeToIndustryName(type) + " at " + name)
	UpdateOptionButtons()
	industryIcons.Reset()


func BuildInfrastructure(type: Enums.InfrastructureType):
	pass
	
	
func SellButtonPressed():
	if industry == null:
		print("ERROR! Sell button pressed on empty block")
	else:
		industry.DecreaseLevel()
		if industry.level == 0:
			industry.free()
			industry = null
			
			if industryBlock != null:
				if industryBlock.get_parent() is IndustrySlot:
					industryBlock.get_parent().RemoveBonus()
				
				industryBlock.queue_free()
				
		UpdateOptionButtons()
		industryIcons.Reset()


func ConnectBuildSignals():
	for child in industryButtons.get_children():
		if child is BuildTypeButton:
			child.pressed.connect(BuildIndustry.bind(child.goodType))
			
	for child in infraButtons.get_children():
		if child is BuildTypeButton:
			child.pressed.connect(BuildInfrastructure.bind(child.infraType))
