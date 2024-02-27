extends Label

var industryPanel = preload("res://Scenes/IndustryPanel.tscn")

@onready var resourceStockLabel = $ResourceStockLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	resourceStockLabel.text = str(int(Game.playerNation.revenue)) + " (" + str(Game.playerNation.revenuePerSecond) + "/s)"


func MakeIndustryPanel() -> IndustryPanel:
	var newPanel: IndustryPanel = industryPanel.instantiate()
	add_child(newPanel)
	
	return newPanel
