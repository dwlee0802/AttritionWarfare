extends CharacterBody2D
class_name CommandMarker

static var location: float


func _physics_process(delta):
	if Input.is_action_pressed("right_click"):
		global_position = get_global_mouse_position()
	else:
		velocity = Vector2(0, 20)
		move_and_collide(velocity)
	
	CommandMarker.location = global_position.x
