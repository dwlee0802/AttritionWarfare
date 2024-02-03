extends RigidBody2D
class_name Projectile

@export var isPlayer: bool = true
var damage: int = 0

var piercing: int = 1


func _ready():
	SetPlayerUnit(isPlayer)
	
	
func SetPlayerUnit(val):
	isPlayer = val
	
	if !isPlayer:
		linear_velocity = Vector2(-800, -200)
		$Area2D.collision_mask = 1
	else:
		linear_velocity = Vector2(800, -200)


func _on_area_2d_body_entered(body):
	print("hit " + body.name)
	
	if piercing > 0:
		if body is Unit:
			body.ReceiveHit(damage)
			piercing -= 1
	queue_free()
	
