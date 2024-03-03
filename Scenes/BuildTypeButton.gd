extends Button
class_name BuildTypeButton

@export var goodType: Enums.GoodType = Enums.GoodType.None

@export var infraType: Enums.InfrastructureType = Enums.InfrastructureType.None

var data: IndustryData


func _ready():
	if goodType != Enums.GoodType.None:
		data = load(Enums.GoodTypeToDataPath(goodType))


func _process(delta):
	if Game.playerNation != null and data != null:
		# check if this button can be pressed based on available funds and cost
		disabled = !Game.playerNation.CheckEnoughFunds(data.levelUpCost)
