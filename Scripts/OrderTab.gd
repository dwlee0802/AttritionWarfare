extends Label
class_name OrderTab

static var order: Enums.OrderType = Enums.OrderType.Offensive


func _on_order_button_pressed(extra_arg_0):
	order = extra_arg_0
	print(order)
