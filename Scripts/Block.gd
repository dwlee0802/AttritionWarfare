extends Control
class_name Block

@onready var detectionArea: Area2D = $GroundTexture/SurfaceTexture/DetectionArea/Area2D

var centerPosition

@export var ignoreCombatWidth: bool = false
var curCombatWidth: int = 0
var maxCombatWidth: int = 1
var tempCombatWidth: int = 0

static var baseCombatWidth: int = 5

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
@onready var destroyButton = $CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Infrastructure/SellButton

@onready var industryButtons = $CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Industry
@onready var infraButtons = $CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Infrastructure

@onready var industryIcons = $CaptureStatus/IndustryIcons

# temporary testing values
@export var terrainType: Terrain
@export var modifiers = []
@export var infrastructures = []

var modifierIconScene = load("res://Scenes/block_modifier_icon.tscn")

var canBuildCoal: bool = false
var canBuildIron: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Industry/SellButton.pressed.connect(SellButtonPressed)
	$CaptureStatus/IndustryIcons/BuildButton/BuildOptions/Infrastructure/SellButton.pressed.connect(DestroyInfraPressed)
	CheckIfCapital()
	
	for i in range(Block.baseCombatWidth):
		var newSlot = slotScene.instantiate()
		slots.append(newSlot)
		slotContainer.add_child(newSlot)
	
	industryIcons.options_toggled.connect(UpdateOptionButtons)
	
	ConnectBuildSignals()
	UpdateOptionButtons()
	
	ReloadIcons()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	centerPosition = detectionArea.global_position.x
	insideUnits = GetUnitsInside()
	UpdateContentsLabel()
	
	debugLabel.text = str(canBuildCoal) + "/" + str(canBuildIron) 
		
	if curCombatWidth < 0:
		curCombatWidth = 0
	
	UpdateCaptureStatus()
	
	
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
			

func UpdateCaptureStateIndicator():
	if captureState == Enums.BlockState.Player:
		captureStatusTexture.self_modulate = Color.DEEP_SKY_BLUE
		
	if captureState == Enums.BlockState.Enemy:
		captureStatusTexture.self_modulate = Color.DARK_RED
		
	if captureState == Enums.BlockState.Neutral:
		captureStatusTexture.self_modulate = Color.GRAY
		
		
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
	
	# update infrastructure buttons
	for child in buildOptions.get_node("Infrastructure").get_children():
		if child is BuildTypeButton:
			# check if the block's terrain type is appropriate for this infrastructure
			if CheckCorrectTypeForInfra(child.infraType) and !infrastructures.has(DataManager.infraData[child.infraType]):
				child.visible = true
				child.cost = DataManager.infraData[child.infraType].cost
				child.text = Enums.InfrastructureTypeToString(child.infraType) + " (" + str(child.cost) + ")"
			else:
				child.visible = false
				
	destroyButton.visible = infrastructures.size() > 0
				

# checks if this block's terrain type allows infra of infraType to be built on
func CheckCorrectTypeForInfra(infraType: Enums.InfrastructureType):
	if terrainType == null:
		return false
		
	# no requirements
	if DataManager.infraData[infraType].requiresType == Enums.TerrainType.None:
		return true
	# requirement is terrain type
	if DataManager.infraData[infraType].requiresType == terrainType.type:
		return true

	return false
	
	
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
			ReloadIcons()
			return
	
	industry = Industry.new(load(Enums.GoodTypeToDataPath(type)))
	add_child(industry)
	industryBlock = IndustryEditor.instance.AddIndustryBlock(industry)
	
	Game.playerNation.ChangeFunds(-500)
	industryIcons.Reset()
	
	print("Built new " + Enums.GoodTypeToIndustryName(type) + " at " + name)
	UpdateOptionButtons()
	industryIcons.Reset()
	ReloadIcons()
	
	
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
		ReloadIcons()


func DestroyInfraPressed():
	infrastructures.clear()
	UpdateOptionButtons()
	industryIcons.Reset()
	ReloadIcons()
	
	
func ConnectBuildSignals():
	for child in industryButtons.get_children():
		if child is BuildTypeButton:
			child.pressed.connect(BuildIndustry.bind(child.goodType))
			
	for child in infraButtons.get_children():
		if child is BuildTypeButton:
			child.pressed.connect(AddInfrastructure.bind(DataManager.infraData[child.infraType]))


func AddModifier(mod: Modifier):
	modifiers.append(mod)
	
	canBuildCoal = mod.coalDeposit
	canBuildIron = mod.ironDeposit
	
	if mod.slotChange < 0:
		if slotContainer.get_child_count() > abs(mod.slotChange):
			for i in range(abs(mod.slotChange)):
				var target = slots.pop_front()
				target.queue_free()
				
	if mod.slotChange > 0:
		for i in range(mod.slotChange):
			var newSlot = slotScene.instantiate()
			slots.append(newSlot)
			slotContainer.add_child(newSlot)
	
	UpdateOptionButtons()
	ReloadIcons()


func AddTerrain(terrain: Terrain):
	if terrain == null:
		print("Warning! Null input in add terrain")
		return
		
	if terrainType != null:
		print("Warning! Overriding already set terrain type!")
	
	terrainType = terrain
	
	if terrain.slotChange < 0:
		if slotContainer.get_child_count() > abs(terrain.slotChange):
			for i in range(abs(terrain.slotChange)):
				var target = slots.pop_front()
				target.queue_free()
				
	if terrain.slotChange > 0:
		for i in range(terrain.slotChange):
			var newSlot = slotScene.instantiate()
			slots.append(newSlot)
			slotContainer.add_child(newSlot)
	
	UpdateOptionButtons()
	ReloadIcons()


func AddInfrastructure(infra: Infrastructure):
	if terrainType != null:
		print("Warning! Overriding already set terrain type!")
		
	infrastructures.append(infra)
	
	if infra.slotChange < 0:
		if slotContainer.get_child_count() > abs(infra.slotChange):
			for i in range(abs(infra.slotChange)):
				var target = slots.pop_front()
				target.queue_free()
				
	if infra.slotChange > 0:
		for i in range(infra.slotChange):
			var newSlot = slotScene.instantiate()
			slots.append(newSlot)
			slotContainer.add_child(newSlot)
	
	UpdateOptionButtons()
	ReloadIcons()


func ReloadIcons():
	# clear current icons except build button
	var first: bool = true
	for child in industryIcons.get_children():
		if first:
			first = false
			continue
		
		child.queue_free()
	
	if terrainType != null:
		var newIcon = modifierIconScene.instantiate()
		newIcon.get_node("TempLabel").text = terrainType.name
		buildButton.add_sibling(newIcon)
	
	# dont show modifiers if they are used
	for mod: Modifier in modifiers:
		if industry != null:
			if mod.type == Enums.ModifierType.CoalDeposit:
				if industry.productionType == Enums.GoodType.Coal:
					continue
			if mod.type == Enums.ModifierType.IronDeposit:
				if industry.productionType == Enums.GoodType.Iron:
					continue
		var newIcon = modifierIconScene.instantiate()
		newIcon.get_node("TempLabel").text = mod.name
		buildButton.add_sibling(newIcon)
	
	for infra in infrastructures:
		var newIcon = modifierIconScene.instantiate()
		newIcon.get_node("TempLabel").text = infra.name
		buildButton.add_sibling(newIcon)
	
	if industry != null:
		var newIcon = modifierIconScene.instantiate()
		newIcon.get_node("TempLabel").text = Enums.GoodTypeToIndustryName(industry.productionType) + " " + str(industry.level)
		buildButton.add_sibling(newIcon)
			

# returns all units inside that has a lower movement priority than input
func GetSwapTarget(isPlayer: bool, priorityLevel: int):
	var candidates = GetUnitsInside(isPlayer)
	var output = []
	for unit : Unit in candidates:
		if unit.movementPriorityLevel < priorityLevel:
			output.append(unit)
			
	return output
	
