extends StaticBody2D
class_name HQ

var unitScene = load("res://Scenes/Unit.tscn")
var infantryData: UnitData = load("res://Data/infantry.tres")
var artilleryData: UnitData = load("res://Data/artillery.tres")
var armoredData: UnitData = load("res://Data/armored.tres")

@export var isPlayerHQ: bool = true

@export var autoSpawn: bool = false

@export var currentBlock: Block

@onready var spawnTimer: Timer = $SpawnTimer
@onready var spawnTimer2: Timer = $SpawnTimer2

var units = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if autoSpawn:
		if spawnTimer.is_stopped():
			spawnTimer.start()
		if spawnTimer2.is_stopped():
			spawnTimer2.start()
	else:
		if !spawnTimer.is_stopped():
			spawnTimer.stop()
		if !spawnTimer2.is_stopped():
			spawnTimer2.stop()
		

# spawns a unit of type unittype at its location
func SpawnUnit(unitType):
	var newUnit: Unit = unitScene.instantiate()
	if unitType == Enums.UnitType.Infantry:
		newUnit.SetStats(infantryData)
	elif unitType == Enums.UnitType.Artillery:
		newUnit.SetStats(artilleryData)
	elif unitType == Enums.UnitType.Armored:
		newUnit.SetStats(armoredData)
		
	add_child(newUnit)
	newUnit.global_position = global_position
	newUnit.SetPlayerUnit(isPlayerHQ)
	newUnit.currentBlock = currentBlock
	newUnit.currentSlot = currentBlock.GetEmptySlot(newUnit.global_position)
	units.append(newUnit)


func _on_auto_spawn_button_toggled(toggled_on):
	autoSpawn = toggled_on


func _on_kill_all_units():
	for unit: Unit in units:
		if is_instance_valid(unit):
			unit.ReceiveHit(1000)
