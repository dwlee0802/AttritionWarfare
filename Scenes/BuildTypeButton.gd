extends Button
class_name BuildTypeButton

@export var goodType: Enums.GoodType = Enums.GoodType.None

@export var infraType: Enums.InfrastructureType = Enums.InfrastructureType.None


func _process(delta):
	# check if this button can be pressed based on available funds and cost
	pass
