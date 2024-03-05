extends Control
class_name World

const MAP_PAN_SPEED: int = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("pan_map_right"):
		global_position += Vector2.LEFT * MAP_PAN_SPEED * delta
	if Input.is_action_pressed("pan_map_left"):
		global_position += Vector2.RIGHT * MAP_PAN_SPEED * delta
