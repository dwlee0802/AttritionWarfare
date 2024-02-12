extends CharacterBody2D
class_name Unit

static var damagePopup = preload("res://Scenes/damage_popup.tscn")

static var bulletScene = preload("res://Scenes/projectile.tscn")

var supplyPriorityLevel: int = 2

# hit points correspond to how much equipment this unit has stocked
var hitPoints: float = 100
@onready var hitPointBar: ProgressBar = $HPProgressBar
@export var speed : int
@export var isPlayerUnit: bool = true
var attackRange: int = 300
@onready var attackArea: Area2D = $AttackArea
var attackTarget

var damageAmount: int = 20
# attack speed in attacks per second
var attackSpeed: float = 1
@onready var attackTimer: Timer = $AttackTimer
var defense: int = 0
var unitData: UnitData

@onready var hitAnimationPlayer = $HitAnimationPlayer

@onready var supplyTimer = $SupplyTimer


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
	damageAmount = data.damageAmount
	attackSpeed = data.attackSpeed
	speed = data.speed
	defense = data.defense
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
	if OrderTab.orderDict[unitData.unitType] != Enums.OrderType.Retreat and len(results) > 0:
		attackTarget = FindClosest(results)
		if attackTimer.is_stopped():
			attackTimer.start(1/ attackSpeed)
	else:
		if !attackTimer.is_stopped():
			attackTimer.stop()
			
		velocity = Vector2.RIGHT * speed
		if !isPlayerUnit:
			velocity *= -1
		else:
			# garrison at command marker
			if OrderTab.orderDict[unitData.unitType] == Enums.OrderType.Defensive:
				# if in front of marker, go back
				if global_position.x >= CommandMarker.locationDict[unitData.unitType]:
					velocity *= -1
			# go back regardless of marker positionf
			if OrderTab.orderDict[unitData.unitType] == Enums.OrderType.Retreat:
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
	
		
func ReceiveHit(amount, pene = 0):
	# check if defense succeeded
	var effDefense = defense - pene
	if effDefense < 0:
		effDefense = 0
	if effDefense > 100:
		effDefense = 100
	
	if randi_range(0, 100) > defense:
		hitPoints -= amount
		Game.MakeDamagePopup(str(amount), global_position, Color.RED)
		hitAnimationPlayer.play("hit_animation")
	else:
		Game.MakeDamagePopup("MISS", global_position, Color.RED)
		
	if hitPoints < 0:
		queue_free()


func AddHP(amount):
	hitPoints += amount
	if amount > 0:
		Game.MakeDamagePopup(str(int(amount)), global_position, Color.GREEN)
		
	if hitPoints > unitData.hitPoints:
		hitPoints = unitData.hitPoints
		

func MakeDamagePopup(text, color = Color.RED):
	var newPopup = damagePopup.instantiate()
	newPopup.get_node("Label").text = text
	newPopup.modulate = color
	add_sibling(newPopup)
	newPopup.position = position
	

func AddIngredient(type, amount):
	AddHP(amount)
	
	
func _on_attack_timer_timeout():
	# check if enough ammo exists
	if isPlayerUnit:
		if !Game.playerNation.ConsumeResource(Enums.GoodType.Ammunition, 1):
			return
			
	var newBullet: Projectile = bulletScene.instantiate()
	newBullet.SetPlayerUnit(isPlayerUnit)
	
	newBullet.explosive = unitData.splashDamage
	
	# make it so its always above 1
	newBullet.damage = damageAmount * GetHPRatio()
	if newBullet.damage <= 0:
		newBullet.damage = 1
		
	get_tree().root.add_child(newBullet)
	newBullet.global_position = global_position


# maintenance consumption
func _on_supply_timer_timeout():
	if isPlayerUnit:
		Game.playerNation.AddSupplyOrder(SupplyOrder.new(self, unitData.supplyConsumptionType, unitData.supplyConsumptionAmount))
		supplyTimer.start(unitData.supplyConsumptionBaseTime + (global_position.x - Game.playerNation.hq.global_position.x) / 100)


func _exit_tree():
	Game.MakeDeathEffect(global_position)
	

func _on_maintenance_timer_timeout():
	ReceiveHit(unitData.maintenanceAmount)


func GetHPRatio() -> float:
	return hitPoints / unitData.hitPoints
