extends StaticBody2D
class_name HQ

var unitScene = load("res://Scenes/Unit.tscn")
@export var isPlayerHQ: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# spawns a unit of type unittype at its location
func SpawnUnit(unitType):
	var newUnit: Unit = unitScene.instantiate()
	add_child(newUnit)
	newUnit.global_position = global_position
	newUnit.SetPlayerUnit(isPlayerHQ)
