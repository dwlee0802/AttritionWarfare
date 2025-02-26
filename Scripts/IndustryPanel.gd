extends Control
class_name IndustryPanel

@onready var nameLabel = $NameLabel
@onready var levelLabel = $LevelLabel
@onready var productionProgressBar: ProgressBar = $ProductionProgressBar
@onready var productionProgressLabel: Label = $ProductionProgressBar/Label

@export var industry: Industry = null

@onready var ingredientIcon1 = $IngredientIcons/IngredientIcon1
@onready var ingredientIcon2 = $IngredientIcons/IngredientIcon2
@onready var ingredientIcon3 = $IngredientIcons/IngredientIcon3

@onready var ingredientLabel1 = $IngredientIcons/Label
@onready var ingredientLabel2 = $IngredientIcons/Label2
@onready var ingredientLabel3 = $IngredientIcons/Label3

@onready var stockpileLabel = $StockpileLabel

@onready var priorityLabel = $PriorityLabel


func _ready():
	if industry != null:
		if industry.ingredientType0 != Enums.GoodType.None:
			$IngredientIcons/Label.text = Enums.GoodTypeToString(industry.ingredientType0)
		else:
			$IngredientIcons/Label.visible = false
			
		if industry.ingredientType1 != Enums.GoodType.None:
			$IngredientIcons/Label2.text = Enums.GoodTypeToString(industry.ingredientType1)
		else:
			$IngredientIcons/Label2.visible = false
			
		if industry.ingredientType2 != Enums.GoodType.None:
			$IngredientIcons/Label3.text = Enums.GoodTypeToString(industry.ingredientType2)
		else:
			$IngredientIcons/Label3.visible = false
		
		industry.good_produced.connect(MakeProductionPopup)
		

func _process(_delta):
	if industry != null:
		nameLabel.text = industry.name
		levelLabel.text = str(industry.level)
		priorityLabel.text = "Priority: " + str(industry.supplyPriorityLevel)
		productionProgressBar.max_value = industry.productionTimer.wait_time
		productionProgressBar.value = industry.productionTimer.wait_time - industry.productionTimer.time_left
		var left_time: String = str(int(industry.productionTimer.time_left * 100) * 0.01)
		productionProgressLabel.text = left_time
		
		# check ingredient status
		if ingredientLabel1.visible == true:
			ingredientLabel1.text = Enums.GoodTypeToString(industry.ingredientType0) + " " + str(int(industry.ingredientType0_Received / industry.ingredientType0_Amount * 100)) + "%"
			if !industry.ingredientType0_available:
				ingredientLabel1.self_modulate = Color.RED
			else:
				ingredientLabel1.self_modulate = Color.WHITE
				
		if ingredientLabel2.visible == true:
			ingredientLabel2.text = Enums.GoodTypeToString(industry.ingredientType1) + " " + str(int(industry.ingredientType1_Received / industry.ingredientType1_Amount * 100)) + "%"
			if !industry.ingredientType1_available:
				ingredientLabel2.self_modulate = Color.RED
			else:
				ingredientLabel2.self_modulate = Color.WHITE
				
		if ingredientLabel3.visible == true:
			ingredientLabel3.text = Enums.GoodTypeToString(industry.ingredientType2) + " " + str(int(industry.ingredientType2_Received / industry.ingredientType2_Amount * 100)) + "%"
			if !industry.ingredientType2_available:
				ingredientLabel3.self_modulate = Color.RED
			else:
				ingredientLabel3.self_modulate = Color.WHITE
				
		# update produced goods stock
		stockpileLabel.text = str(industry.stockpile) + "/" + str(industry.stockpileMax)


# true is up false is down
func _on_change_level_button_pressed(extra_arg_0):
	if extra_arg_0:
		industry.IncreaseLevel(1)
	else:
		industry.DecreaseLevel(1)


# true is up false is down
func _on_change_priority_button_pressed(extra_arg_0):
	if extra_arg_0:
		# level up
		industry.supplyPriorityLevel += 1
	else:
		# level down
		if industry.supplyPriorityLevel == 0:
			return
		else:
			industry.supplyPriorityLevel -= 1


func MakeProductionPopup():
	Game.MakeDamagePopup(Enums.GoodTypeToString(industry.productionType) + " +" + str(industry.productionAmount), global_position, Color.GREEN)
