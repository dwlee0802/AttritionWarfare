extends Node
class_name Industry

@export var level: int = 0
@export_group("Production")
@export var industrySector: Enums.IndustrySector = Enums.IndustrySector.Basic
@export var productionType: Enums.GoodType = Enums.GoodType.None
@export var productionAmount: int = 0
@export var stockpile: int = 0
@export var stockpileMax: int = 100

@export var ingredientType0: Enums.GoodType = Enums.GoodType.None
@export var ingredientType0_Amount: int = 0
var ingredientType0_available: bool = false
@export var ingredientType1: Enums.GoodType = Enums.GoodType.None
@export var ingredientType1_Amount: int = 0
var ingredientType1_available: bool = false
@export var ingredientType2: Enums.GoodType = Enums.GoodType.None
@export var ingredientType2_Amount: int = 0
var ingredientType2_available: bool = false

var allIngredientsAvailable:bool = false

@export var baseProductionTime: float = 1

@onready var productionTimer: Timer = $ProductionTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	productionTimer.timeout.connect(Production)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level == 0:
		productionTimer.stop()
		return
	
	if stockpile >= stockpileMax:
		productionTimer.stop()
		return
	
	allIngredientsAvailable = true
	
	# check if production timer is running
	if productionTimer.is_stopped():
		# check if nation has enough ingredients
		if ingredientType0 != Enums.GoodType.None:
			if !get_parent().get_parent().CheckResourceAvailable(ingredientType0, ingredientType0_Amount):
				ingredientType0_available = false
				allIngredientsAvailable = false
			else:
				ingredientType0_available = true
				
		if ingredientType1 != Enums.GoodType.None:
			if !get_parent().get_parent().CheckResourceAvailable(ingredientType1, ingredientType1_Amount):
				ingredientType1_available = false
				allIngredientsAvailable = false
			else:
				ingredientType1_available = true
				
		if ingredientType2 != Enums.GoodType.None:
			if !get_parent().get_parent().CheckResourceAvailable(ingredientType2, ingredientType2_Amount):
				ingredientType2_available = false
				allIngredientsAvailable = false
			else:
				ingredientType2_available = true
	
		if allIngredientsAvailable:
			# consume ingredients
			get_parent().get_parent().ConsumeResource(ingredientType0, ingredientType0_Amount)
			get_parent().get_parent().ConsumeResource(ingredientType1, ingredientType1_Amount)
			get_parent().get_parent().ConsumeResource(ingredientType2, ingredientType2_Amount)
			
			productionTimer.start(baseProductionTime / level)


func Production():
	stockpile += productionAmount
	if stockpile > stockpileMax:
		stockpile = stockpileMax
		
	#print("Produced " + str(productionAmount) + " of " + Enums.GoodTypeToString(productionType))
