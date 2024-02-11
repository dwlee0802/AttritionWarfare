extends TextureButton

@export var unitType: Enums.UnitType
@export var ingredientType_1: Enums.GoodType = Enums.GoodType.None
@export var ingredientAmount_1: int = 0
@export var ingredientType_2: Enums.GoodType = Enums.GoodType.None
@export var ingredientAmount_2: int = 0
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
	var costText = ""
	if ingredientType_1 != Enums.GoodType.None:
		costText += Enums.GoodTypeToString(ingredientType_1) + " " + str(ingredientAmount_1)
	if ingredientType_2 != Enums.GoodType.None:
		costText += "\n" + Enums.GoodTypeToString(ingredientType_2) + " " + str(ingredientAmount_2)
	costLabel.text = costText
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queuedAmountLabel.text = str(queuedAmount)
	UpdateCooldownShadow(spawnTimer.time_left / spawnTimer.wait_time)
	
	if queuedAmount > 0 and spawnTimer.time_left <= 0:
		if !Game.playerNation.CheckResourceAvailable(ingredientType_1, ingredientAmount_1):
			costLabel.self_modulate = Color.RED
		elif !Game.playerNation.CheckResourceAvailable(ingredientType_2, ingredientAmount_2):
			costLabel.self_modulate = Color.RED
		else:
			costLabel.self_modulate = Color.WHITE
			Game.playerNation.ConsumeResource(ingredientType_1, ingredientAmount_1)
			Game.playerNation.ConsumeResource(ingredientType_2, ingredientAmount_2)
			queuedAmount -= 1
			Game.playerNation.hq.SpawnUnit(unitType)
			spawnTimer.start(spawnCooldown)
			

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
