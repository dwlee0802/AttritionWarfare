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


# Called when the node enters the scene tree for the first time.
func _ready():
	maxCombatWidth = randi_range(1, 9)
	CheckIfCapital()
	
	for i in range(maxCombatWidth):
		var newSlot = slotScene.instantiate()
		slots.append(newSlot)
		slotContainer.add_child(newSlot)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	centerPosition = detectionArea.global_position.x
	insideUnits = GetUnitsInside()
	UpdateContentsLabel()
	debugLabel.text = str(global_position)
	
	if curCombatWidth < 0:
		curCombatWidth = 0
		

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
	var output = []
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
