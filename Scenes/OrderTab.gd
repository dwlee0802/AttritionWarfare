extends Label
class_name OrderTab

static var order: OrderType = OrderType.Offensive
enum OrderType {Offensive, Defensive, Retreat}


func _on_order_button_pressed(extra_arg_0):
	order = extra_arg_0
	print(order)
