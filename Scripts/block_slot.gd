extends TextureRect
class_name BlockSlot

var isOccupied: bool = false

@onready var debugLabel: Label = $DebugLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	debugLabel.text = str(isOccupied)


func GetCenterPosition() -> Vector2:
	return global_position + size / 2

