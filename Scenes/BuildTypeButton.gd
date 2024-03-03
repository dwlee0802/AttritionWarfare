extends Button
class_name BuildTypeButton

@export var goodType: Enums.GoodType = Enums.GoodType.None

@export var infraType: Enums.InfrastructureType = Enums.InfrastructureType.None

var cost: int = 0


func _process(delta):
	if Game.playerNation != null:
		# check if this button can be pressed based on available funds and cost
		disabled = !Game.playerNation.CheckEnoughFunds(cost)
