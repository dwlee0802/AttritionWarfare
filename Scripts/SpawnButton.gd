extends TextureButton

@export var supplyPriorityLevel: int = 1
@export var unitType: Enums.UnitType
@export var ingredientType_1: Enums.GoodType = Enums.GoodType.None
@export var ingredientAmount_1: int = 0
@export var ingredientReceived_1: float = 0
@export var ingredientAvailable_1: bool = true
@export var ingredientType_2: Enums.GoodType = Enums.GoodType.None
@export var ingredientAmount_2: int = 0
@export var ingredientReceived_2: float = 0
@export var ingredientAvailable_2: bool = true
@onready var costLabel: Label = $CostLabel

@export var spawnCooldown: float = 4

var queuedAmount: int = 0

@onready var cooldownShadow: Control = $CooldownShadow
@onready var cooldownLabel: Label = $CooldownLabel
@onready var spawnTimer: Timer = $SpawnTimer
@onready var queuedAmountLabel: Label = $QueuedAmount

@onready var buttonSize: float = size.x


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set cost label
	UpdateIngredientAmount()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queuedAmountLabel.text = str(queuedAmount)
	UpdateCooldownShadow(spawnTimer.time_left / spawnTimer.wait_time)
	UpdateIngredientAmount()
	cooldownLabel.text = str(spawnCooldown) + "s"
	
	if !CheckIngredientsSatisfied():
		costLabel.self_modulate = Color.RED
	else:
		costLabel.self_modulate = Color.WHITE
		
	if queuedAmount > 0 and spawnTimer.time_left <= 0:
		if CheckIngredientsSatisfied():
			queuedAmount -= 1
			Game.playerNation.hq.SpawnUnit(unitType)
			spawnTimer.start(spawnCooldown)
			ingredientReceived_1 = 0
			ingredientReceived_2 = 0
		else:
			# make supply orders
			if !ingredientAvailable_1:
				Game.playerNation.AddSupplyOrder(SupplyOrder.new(self, ingredientType_1, ingredientAmount_1 - ingredientReceived_1))
			
			if !ingredientAvailable_2:
				Game.playerNation.AddSupplyOrder(SupplyOrder.new(self, ingredientType_2, ingredientAmount_2 - ingredientReceived_2))
			

func _pressed():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		queuedAmount -= 1
		if queuedAmount < 0:
			queuedAmount = 0
	else:
		queuedAmount += 1


func UpdateCooldownShadow(percent):
	cooldownShadow.size = Vector2(buttonSize, buttonSize * percent)
	cooldownShadow.position = Vector2(0, buttonSize -  buttonSize * percent)


func UpdateIngredientAmount():
	# Set cost label
	var costText = ""
	if ingredientType_1 != Enums.GoodType.None:
		costText += Enums.GoodTypeToString(ingredientType_1) + " " + str(ingredientReceived_1) + "/" + str(ingredientAmount_1)
	if ingredientType_2 != Enums.GoodType.None:
		costText += "\n" + Enums.GoodTypeToString(ingredientType_2) + " " + str(ingredientReceived_2) + "/" + str(ingredientAmount_2)
	costLabel.text = costText


func AddIngredient(type, amount):
	if type == ingredientType_1:
		ingredientReceived_1 += amount
	elif type == ingredientType_2:
		ingredientReceived_2 += amount
		
		
# Checks if ingredients are sufficient to produce good
func CheckIngredientsSatisfied() -> bool:
	ingredientAvailable_1 = true
	ingredientAvailable_2 = true
			
	if ingredientType_1 != Enums.GoodType.None:
		if ingredientReceived_1 < ingredientAmount_1:
			ingredientAvailable_1 = false
	if ingredientType_2 != Enums.GoodType.None:
		if ingredientReceived_2 < ingredientAmount_2:
			ingredientAvailable_2 = false
	
	return ingredientAvailable_1 and ingredientAvailable_2

