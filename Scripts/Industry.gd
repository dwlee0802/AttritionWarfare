extends Node
class_name Industry

@export var isPlayer: bool = true
@export var level: int = 1
# change assumption so that the industry 'lives' in the IB blocks?
var nation: Nation
@export var levelUpCost: int = 500
@export var data: IndustryData

@export_group("Production")
@export var industrySector: Enums.IndustrySector = Enums.IndustrySector.Basic
@export var productionType: Enums.GoodType = Enums.GoodType.None
@export var productionAmount: int = 0
@export var stockpile: int = 0
@export var stockpileMax: int = 100

@export var baseProductionTime: float = 1
@onready var productionTimer: Timer

@export_group("Ingredients")
# determines the priority in which ingredients are received when there is not enough
# higher priority industries receive ingredients first
@export var supplyPriorityLevel: int = 0
@export var ingredientType0: Enums.GoodType = Enums.GoodType.None
@export var ingredientType0_Amount: int = 0
var ingredientType0_Received: float = 0
var ingredientType0_available: bool = false

@export var ingredientType1: Enums.GoodType = Enums.GoodType.None
@export var ingredientType1_Amount: int = 0
var ingredientType1_Received: float = 0
var ingredientType1_available: bool = false

@export var ingredientType2: Enums.GoodType = Enums.GoodType.None
@export var ingredientType2_Amount: int = 0
var ingredientType2_Received: float = 0
var ingredientType2_available: bool = false

var allIngredientsAvailable:bool = false

signal good_produced

# how much bonus this gives to its neighbors
var bonusAmount: float = 0.1
# how much this got
var receivedBonusAmount: float = 0

var active: bool = false


func _init(_data: IndustryData = null):
	if _data != null:
		data = _data
		productionType = data.productionType
		productionAmount = data.productionAmount
		baseProductionTime = data.baseProductionTime
		industrySector = data.industrySector
		levelUpCost = data.levelUpCost
		
		ingredientType0 = data.ingredientType0
		ingredientType0_Amount = data.ingredientType0_Need
		ingredientType1 = data.ingredientType1
		ingredientType1_Amount = data.ingredientType1_Need
		ingredientType2 = data.ingredientType2
		ingredientType2_Amount = data.ingredientType2_Need
	
	#print("ERROR! No data in Industry")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	productionTimer = get_node_or_null("ProductionTimer")
	
	if productionTimer == null:
		productionTimer = Timer.new()
		add_child(productionTimer)
		productionTimer.one_shot = true
	
	productionTimer.timeout.connect(Production)
	
	if isPlayer:
		nation = Game.playerNation
	else:
		nation = Game.enemyNation


func _process(delta):
	if level == 0:
		productionTimer.stop()
		return
		
	if isPlayer:
		if !Game.playerNation.CheckStockSpace(productionType, productionAmount):
			productionTimer.stop()
			return
	
	# disable if not placed in an industry slot
	if !active:
		if !productionTimer.is_stopped():
			productionTimer.stop()
		return
		
		
	allIngredientsAvailable = CheckIngredientsSatisfied()
	
	
	# start by checking if production is currently in process
	if productionTimer.is_stopped():
		# check if there is enough ingredients in self's stockpile
		# if enough ingredients, produce good
		if allIngredientsAvailable:
			productionTimer.start(baseProductionTime / level * (1 - receivedBonusAmount))
		else:
			# if not enough ingredients, place supply orders to Nation
			if ingredientType0 != Enums.GoodType.None:
				if ingredientType0_Received < ingredientType0_Amount:
					var newOrder = SupplyOrder.new(self, ingredientType0, ingredientType0_Amount - ingredientType0_Received)
					nation.AddSupplyOrder(newOrder)
			# if not enough ingredients, place supply orders to Nation
			if ingredientType1 != Enums.GoodType.None:
				if ingredientType1_Received < ingredientType1_Amount:
					var newOrder = SupplyOrder.new(self, ingredientType1, ingredientType1_Amount - ingredientType1_Received)
					nation.AddSupplyOrder(newOrder)
			# if not enough ingredients, place supply orders to Nation
			if ingredientType2 != Enums.GoodType.None:
				if ingredientType2_Received < ingredientType2_Amount:
					var newOrder = SupplyOrder.new(self, ingredientType2, ingredientType2_Amount - ingredientType2_Received)
					nation.AddSupplyOrder(newOrder)


func Production():
	Game.playerNation.AddResource(productionType, productionAmount)
	ingredientType0_Received = false
	ingredientType1_Received = false
	ingredientType2_Received = false
	
	good_produced.emit()
	
	
# Checks if ingredients are sufficient to produce good
func CheckIngredientsSatisfied() -> bool:
	ingredientType0_available = true
	ingredientType1_available = true
	ingredientType2_available = true
			
	if ingredientType0 != Enums.GoodType.None:
		if ingredientType0_Received < ingredientType0_Amount:
			ingredientType0_available = false
	if ingredientType1 != Enums.GoodType.None:
		if ingredientType1_Received < ingredientType1_Amount:
			ingredientType1_available = false
	if ingredientType2 != Enums.GoodType.None:
		if ingredientType2_Received < ingredientType2_Amount:
			ingredientType2_available = false
	
	return ingredientType0_available and ingredientType1_available and ingredientType2_available


func AddIngredient(type, amount):
	if ingredientType0 == type:
		ingredientType0_Received += amount
		return
	if ingredientType1 == type:
		ingredientType1_Received += amount
		return
	if ingredientType2 == type:
		ingredientType2_Received += amount
		return
	

# might be better to decouple these?
func IncreaseLevel(amount: int = 1):
	if isPlayer:
		if Game.playerNation.funds >= levelUpCost * amount:
			Game.playerNation.funds -= levelUpCost * amount
			level += 1


func DecreaseLevel(amount: int = 1):
	if level < amount:
		return
	
	if isPlayer:
		Game.playerNation.funds += levelUpCost * 0.8 * amount
		level -= amount
