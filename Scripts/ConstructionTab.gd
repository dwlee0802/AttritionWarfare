extends Label
class_name ConstructionTab

@onready var fundsLabel: Label = $FundsLabel

static var isBuildMode: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fundsLabel.text = "Funds: " + str(int(Game.playerNation.funds))


func _on_build_toggled(toggled_on):
	isBuildMode = toggled_on
