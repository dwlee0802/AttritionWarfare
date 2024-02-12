extends Label
class_name OrderTab

static var order: Enums.OrderType = Enums.OrderType.Offensive
static var orderDict = {
	Enums.UnitType.Infantry: Enums.OrderType.Defensive,
	Enums.UnitType.Artillery: Enums.OrderType.Defensive,
	Enums.UnitType.Armored: Enums.OrderType.Defensive,
	Enums.UnitType.Antitank: Enums.OrderType.Defensive
	}
	
static var selectedType: Enums.UnitType


# 0 is offense, 1 is defense, 2 is retreat
func _on_order_button_pressed(unitType, orderType):
	orderDict[unitType] = orderType
	print("Set " + str(unitType) + " to " + str(orderDict[unitType]))


func _on_set_all_button_pressed(extra_arg_0):
	for key in orderDict.keys():
		orderDict[key] = extra_arg_0


func _on_marker_select_pressed(unitType):
	selectedType = unitType
