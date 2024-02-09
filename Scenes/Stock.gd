extends Label
class_name Stockpile

@export var isPlayer: bool = true
@export var type: Enums.GoodType
@onready var progressBar: ProgressBar = $ProgressBar
@onready var amountLabel: Label = $AmountLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isPlayer:
		amountLabel.text = str(Game.playerNation.resources[type]) + "/" + str(Game.playerNation.stockMax[type])
		progressBar.max_value = Game.playerNation.stockMax[type]
		progressBar.value = Game.playerNation.resources[type]
