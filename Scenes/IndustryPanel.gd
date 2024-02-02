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
		
		
func SetProductionProgress(value):
	productionProgressBar.value = value
	productionProgressLabel.text = str(int(value * 100) * 0.01)


func SetProductionProgressMax(value):
	productionProgressBar.max_value = value
	
	
func SetIngredientProgress(value):
	ingredientProgressBar.value = value
	ingredientProgressLabel.text = str(int(value * 100) * 0.01)
	
	
func SetIngredientProgressMax(value):
	ingredientProgressBar.max_value = value
	
