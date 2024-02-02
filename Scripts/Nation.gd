extends Node
class_name Nation

@export var resources = [0, 0, 0, 0, 0, 0]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func PrintResourceStock():
	var output = ""
	for i in range(Enums.GOOD_TYPE_COUNT):
		output += Enums.GoodTypeToString(i) + ": " + str(resources[i]) + "  "
	return output
