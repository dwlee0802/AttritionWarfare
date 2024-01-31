extends StaticBody2D
class_name HQ

var unitScene = load("res://Scene/Unit.tscn")
@export var isPlayerHQ: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# spawns a unit of type unittype at its location
func SpawnUnit(unitType):
	var newUnit: Node = unitScene.instantiate()
	add_child(newUnit)
	newUnit.position = position


func _on_spawn_timer_timeout():
	SpawnUnit(0)
