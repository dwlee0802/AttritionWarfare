extends Node
class_name Industry

@export var isPlayer: bool = true
@export var level: int = 0
@onready var nation: Nation = get_parent().get_parent()
@export var levelUpCost: int = 500

@export_group("Production")
@export var industrySector: Enums.IndustrySector = Enums.IndustrySector.Basic
@export var productionType: Enums.GoodType = Enums.GoodType.None
@export var productionAmount: int = 0
@export var stockpile: int = 0
@export var stockpileMax: int = 100

@export var baseProductionTime: float = 1
@onready var productionTimer: Timer = $ProductionTimer

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


# Called when the node enters the scene tree for the first time.
func _ready():
	productionTimer.timeout.connect(Production)


func _process(delta):
	if level == 0:
		productionTimer.stop()
		return
		
	if isPlayer:
		if !Game.playerNation.CheckStockSpace(productionType, productionAmount):
			productionTimer.stop()
			return
	
	allIngredientsAvailable = CheckIngredientsSatisfied()
	
	
	# start by checking if production is currently in process
	if productionTimer.is_stopped():
		# check if there is enough ingredients in self's stockpile
		# if enough ingredients, produce good
		if allIngredientsAvailable:
			productionTimer.start(baseProductionTime / level)
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
	

func IncreaseLevel(amount: int = 1):
	if isPlayer:
		if Game.playerNation.revenue >= levelUpCost * amount:
			Game.playerNation.revenue -= levelUpCost * amount
			level += 1


func DecreaseLevel(amount: int = 1):
	if level < amount:
		return
	
	if isPlayer:
		Game.playerNation.revenue += levelUpCost * 0.8 * amount
		level -= amount
