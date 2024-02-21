extends TextureRect
class_name Block

@onready var detectionArea: Area2D = $DetectionArea/Area2D

var curCombatWidth: int = 0
var maxCombatWidth: int = 1

@onready var contentsLabel: RichTextLabel = $ContentsLabel

var insideUnits

var nextBlock: Block
var prevBlock: Block

@onready var debugLabel: Label = $DebugLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	insideUnits = GetUnitsInside()
	UpdateContentsLabel()
	debugLabel.text = str(global_position)


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
	
	if len(countDict.keys()) != 0:
		output += "[fill]Total: "+ str(curCombatWidth) + "/" + str(maxCombatWidth) + "[/fill]\n"
	
	contentsLabel.text = output


# units are considered 'on' this block only if their position is equal or greater than self's width
# specifically, unit's position should be inside [self.global_position, self.global_position + size.x)
func GetUnitsInside():
	var results = detectionArea.get_overlapping_bodies()
	var output = []
	curCombatWidth = 0
	for unit in results:
		if unit is Unit:
			if unit.global_position.x >= global_position.x and unit.global_position.x < global_position.x + size.x:
				output.append(unit)
				curCombatWidth += 1
				unit.currentBlock = self
	
	return output


func isFull() -> bool:
	if curCombatWidth < maxCombatWidth:
		return false
	else:
		return true


func GivePermission():
	if curCombatWidth + 1 <= maxCombatWidth:
		curCombatWidth += 1
		return true
	else:
		return false
