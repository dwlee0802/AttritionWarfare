extends CharacterBody2D
class_name Unit

static var damagePopup = preload("res://Scenes/damage_popup.tscn")

static var bulletScene = preload("res://Scenes/projectile.tscn")

var supplyPriorityLevel: int = 0
var hitPoints: int = 100
@onready var hitPointBar: ProgressBar = $HPProgressBar
@export var speed : int
@export var isPlayerUnit: bool = true
var attackRange: int = 300
@onready var attackArea: Area2D = $AttackArea
var attackTarget
var minDamage: int = 20
var maxDamage: int = 40
# attack speed in attacks per second
var attackSpeed: float = 1
@onready var attackTimer: Timer = $AttackTimer
var unitData: UnitData

@onready var hitAnimationPlayer = $HitAnimationPlayer


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
		hitPointBar.self_modulate = Color.RED
	

func SetStats(data: UnitData):
	hitPoints = data.hitPoints
	attackRange = data.attackRange
	minDamage = data.minDamage
	maxDamage = data.maxDamage
	attackSpeed = data.attackSpeed
	speed = data.speed
	unitData = data
	
	if data.unitType == Enums.UnitType.Infantry:
		$Sprite2D.modulate = Color.DARK_OLIVE_GREEN
	elif data.unitType == Enums.UnitType.Artillery:
		$Sprite2D.modulate = Color.DARK_RED
	elif data.unitType == Enums.UnitType.Armored:
		$Sprite2D.modulate = Color.DIM_GRAY
	else:
		queue_free()
		
	
func _physics_process(delta):
	var results = attackArea.get_overlapping_bodies()
	
	if len(results) > 0:
		attackTarget = FindClosest(results)
		if attackTimer.is_stopped():
			attackTimer.start(attackSpeed)
	else:
		if !attackTimer.is_stopped():
			attackTimer.stop()
			
		velocity = Vector2.RIGHT * speed
		if !isPlayerUnit:
			velocity *= -1
		else:
			# garrison at command marker
			if OrderTab.order == Enums.OrderType.Defensive:
				# if in front of marker, go back
				if global_position.x >= CommandMarker.location:
					velocity *= -1
			# go back regardless of marker position
			if OrderTab.order == Enums.OrderType.Retreat:
				if global_position.x > Game.playerNation.hq.global_position.x:
					velocity *= -1
				else:
					return
			
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
	hitAnimationPlayer.play("hit_animation")
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
	

func AddIngredient(type, amount):
	pass
	
	
func _on_attack_timer_timeout():
	# check if enough ammo exists
	if isPlayerUnit:
		if !Game.playerNation.ConsumeResource(Enums.GoodType.Ammunition, 1):
			return
			
	var newBullet: Projectile = bulletScene.instantiate()
	newBullet.SetPlayerUnit(isPlayerUnit)
	
	newBullet.explosive = unitData.splashDamage
	
	newBullet.damage = randi_range(minDamage, maxDamage)
	get_tree().root.add_child(newBullet)
	newBullet.global_position = global_position


# try to consume resources from national stockpile
func _on_supply_timer_timeout():
	if isPlayerUnit:
		pass
