extends Control
class_name IndustryPanel


@onready var nameLabel = $NameLabel
@onready var levelLabel = $LevelLabel
@onready var productionProgressBar: ProgressBar = $ProductionProgressBar
@onready var productionProgressLabel: Label = $ProductionProgressBar/Label
@onready var ingredientProgressBar: ProgressBar = $IngredientProgressBar
@onready var ingredientProgressLabel: Label = $IngredientProgressBar/Label

@export var industry: Industry = null


func _process(delta):
	if industry != null:
		nameLabel.text = industry.name
		levelLabel.text = str(industry.level)
		productionProgressBar.max_value = industry.productionTimer.wait_time
		productionProgressBar.value = industry.productionTimer.wait_time - industry.productionTimer.time_left
		productionProgressLabel.text = str(industry.productionTimer.time_left)
