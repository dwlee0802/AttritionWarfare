extends RigidBody2D
class_name Projectile

@export var isPlayer: bool = true
var damage: int = 0

var piercing: int = 1

var explosive: bool = false
@onready var explosionArea = $ExplosionArea


func _ready():
	SetPlayerUnit(isPlayer)
	
	
func SetPlayerUnit(val):
	isPlayer = val
	
	if !isPlayer:
		linear_velocity = Vector2(-800, -200)
		$Area2D.collision_mask = 1
		$ExplosionArea.collision_mask = 1
	else:
		linear_velocity = Vector2(800, -200)


func SetInitialVelocity(vec):
	linear_velocity = vec
	
	if !isPlayer:
		linear_velocity = vec * Vector2.LEFT
	
	
func _on_area_2d_body_entered(body):
	if piercing > 0:
		if explosive:
			var results = explosionArea.get_overlapping_bodies()
			for item in results:
				if item is Unit:
					item.ReceiveHit(damage)
					
		elif body is Unit:
			body.ReceiveHit(damage)
			piercing -= 1
	
				
	queue_free()
	
