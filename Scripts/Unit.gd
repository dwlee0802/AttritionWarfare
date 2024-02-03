extends CharacterBody2D
class_name Unit

static var damagePopup = preload("res://Scenes/damage_popup.tscn")

static var bulletScene = preload("res://Scenes/projectile.tscn")

var hitPoints: int = 100
@onready var hitPointBar: ProgressBar = $HPProgressBar
@export var speed : int = 200
@export var isPlayerUnit: bool = true
var attackRange: int = 500
@onready var attackArea: Area2D = $AttackArea
var attackTarget
var minDamage: int = 20
var maxDamage: int = 40
# attack speed in attacks per second
var attackSpeed: float = 1
@onready var attackTimer: Timer = $AttackTimer


func _ready():
	attackArea.get_node("CollisionShape2D").shape.size = Vector2(attackRange, 20)
	SetPlayerUnit(isPlayerUnit)
	hitPointBar.max_value = hitPoints
	

func _process(delta):
	hitPointBar.value = hitPoints


func SetPlayerUnit(val):
	isPlayerUnit = val
	
	if !isPlayerUnit:
		collision_layer = 2
		attackArea.collision_mask = 1
	
	
func _physics_process(delta):
	var results = attackArea.get_overlapping_bodies()
	
	if len(results) > 0:
		attackTarget = FindClosest(results)
		if attackTimer.is_stopped():
			attackTimer.start()
	else:
		if !attackTimer.is_stopped():
			attackTimer.stop()
			
		velocity = Vector2.RIGHT * speed
		if !isPlayerUnit:
			velocity *= -1
			
		move_and_slide()
		

func FindClosest(units):
	if len(units) == 0:
		return null
	if len(units) == 1:
		return units[0]
		
	var minDist = 100000
	var output
	
	for item in units:
		var newDist = global_position.distance_to(item.global_position)
		if newDist < minDist:
			minDist = newDist
			output = item
	
	return output
	
		
func ReceiveHit(amount):
	hitPoints -= amount
	MakeDamagePopup(str(amount))
	if hitPoints < 0:
		print("dead!")
		Game.MakeDeathEffect(global_position)
		queue_free()


func MakeDamagePopup(text, color = Color.RED):
	var newPopup = damagePopup.instantiate()
	newPopup.get_node("Label").text = text
	newPopup.modulate = color
	add_sibling(newPopup)
	newPopup.position = position
	
	
func _on_attack_timer_timeout():
	var newBullet: Projectile = bulletScene.instantiate()
	newBullet.SetPlayerUnit(isPlayerUnit)
	newBullet.damage = randi_range(minDamage, maxDamage)
	add_child(newBullet)
