extends RigidBody2D
class_name Projectile

@export var isPlayer: bool = true
var damage: int = 0

var piercing: int = 1

var explosive: bool = false
@onready var explosionArea = $ExplosionArea

var target_location: Vector2

@export var SPEED: int = 1000

const STOP_DIST: int = 5

@onready var sprite: Polygon2D = $Polygon2D


func _ready():
	SetPlayerUnit(isPlayer)
	
	
func SetPlayerUnit(val):
	isPlayer = val
	
	if !isPlayer:
		$Area2D.collision_mask = 1
		$ExplosionArea.collision_mask = 1


func _physics_process(_delta):
	if abs(global_position.distance_to(target_location)) < STOP_DIST:
		queue_free()
		
	sprite.rotate(global_position.angle_to_point(target_location))
	
		
func SetInitialVelocity(loc):
	linear_velocity = global_position.direction_to(loc).normalized() * SPEED
	target_location = loc
	
	
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
	
