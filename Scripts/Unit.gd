extends CharacterBody2D
class_name Unit

static var damagePopup = preload("res://Scenes/damage_popup.tscn")

static var bulletScene = preload("res://Scenes/projectile.tscn")

var supplyPriorityLevel: int = 2

var movementPriorityLevel: int = 0

# hit points correspond to how much equipment this unit has stocked
var hitPoints: float = 100
@onready var hitPointBar: ProgressBar = $HPProgressBar
@export var speed : int
@export var isPlayerUnit: bool = true
var attackRange: int = 300
@onready var attackArea: Area2D = $AttackArea
var attackTarget
var attackTargetBlock: Block = null

var damageAmount: int = 20
# attack speed in attacks per second
var attackSpeed: float = 1
@onready var attackTimer: Timer = $AttackTimer
var defense: int = 0

@export var unitData: UnitData

@onready var hitAnimationPlayer = $HitAnimationPlayer

@onready var supplyTimer = $SupplyTimer

var entrenchment: float = 0
var maxEntrenchment: float = 25
@onready var entrenchmentBar: ProgressBar = $EntrenchmentBar

# movement related variables
var target_position: float
static var POSITION_ERROR = 5

var currentBlock: Block
var currentSlot: BlockSlot
@onready var destinationLine = $Line2D
var hasPermission: bool = false
var hasVisitedCurrentBlock: bool = true

@onready var debugLabel: Label = $DebugLabel
var debugStatus: String = ""
@onready var debugLine: Line2D = $DebugLine

signal current_block_changed


func _ready():
	attackArea.get_node("CollisionShape2D").shape.size = Vector2(attackRange, 20)
	SetPlayerUnit(isPlayerUnit)
	hitPointBar.max_value = hitPoints
	target_position = global_position.x
	

func _process(_delta):
	hitPointBar.value = hitPoints
	entrenchmentBar.max_value = maxEntrenchment
	entrenchmentBar.value = entrenchment
	
	# update debug label
	debugLabel.text = debugStatus
	if currentBlock != null:
		debugLabel.text += "\ncur: " + str(currentBlock.global_position)
	
		if currentSlot != null:
			destinationLine.visible = true
			destinationLine.set_point_position(1, currentSlot.GetCenterPosition() - global_position)
		else:
			destinationLine.visible = false
	
	if attackTarget != null:
		debugLine.visible = true
		debugLine.set_point_position(1, attackTarget.global_position - global_position)
	else:
		debugLine.visible = false
	
	#debugLabel.text = str(attackTarget == null)


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
	#var results = attackArea.get_overlapping_bodies()
	
	# dont try to attack when retreating
	
	#if OrderTab.orderDict[unitData.unitType] != Enums.OrderType.Retreat and attackTarget != null:
		#if attackTimer.is_stopped():
			#attackTimer.start(1/ attackSpeed)
	#else:
		## stop attack timer
		#if !attackTimer.is_stopped():
			#attackTimer.stop()
		#
	UpdateTargetPosition()
	UpdateVelocity()
		#
	if velocity == Vector2.ZERO and attackTarget == null:
		ChangeEntrenchment(delta)
	else:
		ChangeEntrenchment(-delta)
		
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
	

# tries to receive a unit to attack within its attackBlock Range
# close ones are prioritized
func SearchForAttackTarget() -> Unit:
	var newTarget = null
	if currentBlock == null:
		return null
		
	var nextBlock
	if !isPlayerUnit:
		if currentBlock.prevBlock == null:
			return null
		nextBlock = currentBlock.prevBlock
	else:
		if currentBlock.nextBlock == null:
			return null
		nextBlock = currentBlock.nextBlock
		
	for i in range(unitData.attackBlockRange):
		if nextBlock == null:
			break
			
		newTarget = FindClosest(nextBlock.GetUnitsInside(!isPlayerUnit))
		if newTarget != null:
			break
			
		if !isPlayerUnit:
			nextBlock = nextBlock.prevBlock
		else:
			nextBlock = nextBlock.nextBlock
			
	return newTarget
		
		
func ReceiveHit(amount, pene = 0):
	# check if defense succeeded
	var effDefense = defense - pene + entrenchment
	if effDefense < 0:
		effDefense = 0
	if effDefense > 100:
		effDefense = 100
	
	if randi_range(0, 100) > defense:
		hitPoints -= amount
		var popup = Game.MakeDamagePopup(str(amount), global_position, Color.RED)
		popup.global_position = global_position
		hitAnimationPlayer.play("hit_animation")
		ChangeEntrenchment(-1)
	else:
		Game.MakeDamagePopup("MISS", global_position, Color.RED)
		
	if hitPoints < 0:
		if currentBlock != null:
			currentBlock.curCombatWidth -= 1
			currentSlot.isOccupied = false
			
		if isPlayerUnit:
			Game.playerNation.hq.units.erase(self)
		else:
			Game.enemyNation.hq.units.erase(self)
			
		queue_free()


func AddHP(amount):
	hitPoints += amount
	if amount > 0:
		Game.MakeDamagePopup(str(int(amount)), global_position, Color.GREEN)
		
	if hitPoints > unitData.hitPoints:
		hitPoints = unitData.hitPoints
		

func ChangeEntrenchment(amount):
	entrenchment += amount
	if entrenchment < 0:
		entrenchment = 0
	if entrenchment > maxEntrenchment:
		entrenchment = maxEntrenchment
	
	
func MakeDamagePopup(text, color = Color.RED):
	var newPopup = damagePopup.instantiate()
	newPopup.get_node("Label").text = text
	newPopup.modulate = color
	add_sibling(newPopup)
	newPopup.position = position
	

func AddIngredient(_type, amount):
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
	
	newBullet.global_position = global_position
	if attackTarget != null:
		newBullet.SetInitialVelocity(attackTarget.global_position)
		
	get_tree().root.add_child(newBullet)


# maintenance consumption
func _on_supply_timer_timeout():
	if unitData != null and isPlayerUnit:
		Game.playerNation.AddSupplyOrder(SupplyOrder.new(self, unitData.supplyConsumptionType, unitData.supplyConsumptionAmount))
		supplyTimer.start(unitData.supplyConsumptionBaseTime + (global_position.x - Game.playerNation.hq.global_position.x) / 100)


func _exit_tree():
	Game.MakeDeathEffect(global_position)
	

func _on_maintenance_timer_timeout():
	if unitData != null:
		ReceiveHit(unitData.maintenanceAmount)


func GetHPRatio() -> float:
	return hitPoints / unitData.hitPoints
	
	
func UpdateTargetPosition():
	if isPlayerUnit:
		if OrderTab.orderDict[unitData.unitType] == Enums.OrderType.Retreat:
			target_position = Game.playerNation.hq.global_position.x
		
		if OrderTab.orderDict[unitData.unitType] == Enums.OrderType.Offensive:
			target_position = Game.enemyNation.hq.global_position.x
		
		if OrderTab.orderDict[unitData.unitType] == Enums.OrderType.Defensive:
			target_position = CommandMarker.locationDict[unitData.unitType]
	else:
		target_position = Game.playerNation.hq.global_position.x


# try to go to next block
# if cant then go to current block
func UpdateVelocity() -> bool:
	if currentBlock == null:
		velocity = Vector2.ZERO
		debugStatus = "ERROR! No current block."
		return false
	elif currentSlot == null:
		currentSlot = currentBlock.GetEmptySlot(global_position)
		velocity = Vector2.ZERO
		debugStatus = "ERROR! No current slot."
		return false
		
	if !hasVisitedCurrentBlock:
		# go there
		velocity = global_position.direction_to(currentSlot.GetCenterPosition()).normalized() * speed
		debugStatus = "moving to current"
		hasVisitedCurrentBlock = AtCurrent()
		return false
	else:
		attackTarget = SearchForAttackTarget()
		
		# check if we can attack
		if attackTarget != null:
			if !attackTarget.current_block_changed.is_connected(SetAttackTargetToNull):
				attackTarget.current_block_changed.connect(SetAttackTargetToNull)
			velocity = Vector2.ZERO
			if attackTimer.is_stopped():
				attackTimer.start(1/ attackSpeed)
				return false
		else:
			if !attackTimer.is_stopped():
				attackTimer.stop()
				
			if AtTarget():
				velocity = Vector2.ZERO
				debugStatus = "At target location" + "\n permission: " + str(hasPermission)
				return true
			else:
				var nextBlock: Block = currentBlock.nextBlock
			
				if target_position < global_position.x:
					nextBlock = currentBlock.prevBlock
				
				if nextBlock == null:
					velocity = Vector2.ZERO
					debugStatus = "no path"
					return false
				else:
					var nextSlot = nextBlock.GetEmptySlot(global_position)
					
					if nextSlot != null:
						currentSlot.isOccupied = false
						hasVisitedCurrentBlock = false
						debugStatus = "have permission"
						currentSlot = nextSlot
						currentBlock = nextBlock
						current_block_changed.emit()
						velocity = global_position.direction_to(currentSlot.GetCenterPosition()).normalized() * speed
						return false
					else:
						# no space. See if the block desired has units that has lower priority than this
						var potentialSwapTargets = nextBlock.GetSwapTarget(isPlayerUnit, movementPriorityLevel)
						if potentialSwapTargets == null:
							debugStatus = "no space"
							velocity = Vector2.ZERO
							return false
						else:
							# swap positions
							SwapPositions(FindClosest(potentialSwapTargets))
				
	return false


# unit should move to current block when it can't go to any other blocks
func AtCurrent():
	if abs(currentSlot.GetCenterPosition().distance_to(global_position)) < POSITION_ERROR:
		return true
	return false


func AtTarget():
	return abs(target_position - global_position.x) < POSITION_ERROR


func SetAttackTargetToNull():
	attackTarget = null


# swap current locations without unoccupying blocks
# UpdateVelocity should take care of the actual moving since hasVisitedCurrentBlock is set to false
func SwapPositions(target: Unit):
	var curSlot = currentSlot
	var curBlock = currentBlock
	currentSlot = target.currentSlot
	currentBlock = target.currentBlock
	target.currentSlot = curSlot
	target.currentBlock = curBlock
	hasVisitedCurrentBlock = false
	target.hasVisitedCurrentBlock = false
