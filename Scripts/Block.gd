extends TextureRect
class_name Block

@onready var detectionArea: Area2D = $DetectionArea/Area2D

var maxCombatWidth: int = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(len(detectionArea.get_overlapping_bodies()))


func UpdateContentsLabel():
	var output = ""
	
	return output
