extends Node
class_name Industry

@export var level: int = 0
@export_group("Production")
@export var industrySector: Enums.IndustrySector = Enums.IndustrySector.Basic
@export var productionType: Enums.GoodType = Enums.GoodType.None
@export var productionAmount: int = 0

@export var ingredientType0: Enums.GoodType = Enums.GoodType.None
@export var ingredientType0_Amount: int = 0
@export var ingredientType1: Enums.GoodType = Enums.GoodType.None
@export var ingredientType1_Amount: int = 0
@export var ingredientType2: Enums.GoodType = Enums.GoodType.None
@export var ingredientType2_Amount: int = 0

@onready var productionTimer: Timer = $ProductionTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	productionTimer.timeout.connect(Production)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level == 0:
		return
		
	# check if production timer is running
	if productionTimer.is_stopped():
		# check if nation has enough ingredients
		if ingredientType0 != Enums.GoodType.None:
			if Game.playerNation.resources[ingredientType0] < ingredientType0_Amount:
				return
			else:
				Game.playerNation.resources[ingredientType0] -= ingredientType0_Amount
				
		if ingredientType1 != Enums.GoodType.None:
			if Game.playerNation.resources[ingredientType1] < ingredientType1_Amount:
				return
			else:
				Game.playerNation.resources[ingredientType1] -= ingredientType1_Amount
				
		if ingredientType2 != Enums.GoodType.None:
			if Game.playerNation.resources[ingredientType2] < ingredientType2_Amount:
				return
			else:
				Game.playerNation.resources[ingredientType2] -= ingredientType2_Amount
			
		productionTimer.start()


func Production():
	get_parent().get_parent().resources[productionType] += productionAmount
	#print("Produced " + str(productionAmount) + " of " + Enums.GoodTypeToString(productionType))


