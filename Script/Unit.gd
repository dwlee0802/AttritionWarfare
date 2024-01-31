extends CharacterBody2D
class_name Unit

var speed : int = 100
var isPlayerUnit: bool = true
var attackRange: int = 150


func _ready():
	if !isPlayerUnit:
		collision_layer = 2
		
	$AttackArea/CollisionShape2D.shape.size = Vector2(attackRange, 20)


func _physics_process(delta):
	velocity = Vector2.RIGHT * speed
	if !isPlayerUnit:
		velocity *= -1
		
	move_and_slide()
