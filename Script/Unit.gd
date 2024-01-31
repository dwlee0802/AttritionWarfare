extends CharacterBody2D
class_name Unit

var speed : int = 100
var isPlayerUnit: bool = true
var attackRange: int = 150
@onready var attackArea: Area2D = $AttackArea


func _ready():
	attackArea.get_node("CollisionShape2D").shape.size = Vector2(attackRange, 20)


func SetPlayerUnit(val):
	isPlayerUnit = val
	
	if !isPlayerUnit:
		collision_layer = 2
		attackArea.collision_mask = 1
	
	
func _physics_process(delta):
	var results = attackArea.get_overlapping_bodies()
	
	if len(results) > 0:
		print("target detected")
		print(results[0].name)
	else:
		velocity = Vector2.RIGHT * speed
		if !isPlayerUnit:
			velocity *= -1
			
		move_and_slide()
		
		
	
