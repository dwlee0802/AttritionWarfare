extends Node
class_name Nation

@export var resources = [0, 0, 0, 0, 0, 0, 0]
@export var stockMax = [100, 100, 100, 100, 100, 100, 100]
var industries = []

@export var hq: HQ

# supply order system
# 3D array of supply orders
# first index is the good type of the request
# second index is the priority levels of the request
# third is the actual order
var supplyOrders = []
const MAX_PRIORITY_LEVEL: int = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in get_node("Industry").get_children():
		industries.append(item)
	
	for i in range(Enums.GOOD_TYPE_COUNT):
		var new2D = Array()
		for j in range(MAX_PRIORITY_LEVEL):
			var newList = Array()
			new2D.append(newList)
			
		supplyOrders.append(new2D)
		
	ClearSupplyOrders()


func ClearSupplyOrders():
	for i in range(Enums.GOOD_TYPE_COUNT):
		for j in range(MAX_PRIORITY_LEVEL):
			supplyOrders[i][j].clear()


func AddSupplyOrder(order: SupplyOrder):
	supplyOrders[order.goodType][order.origin.supplyPriorityLevel].append(order)
	

func ProcessSupplyOrders():
	for type in range(Enums.GOOD_TYPE_COUNT):
		for level in range(MAX_PRIORITY_LEVEL):
			if len(supplyOrders[type][level]) == 0:
				continue
				
			var averageAmount: float = resources[type] / len(supplyOrders[type][level])
			for order: SupplyOrder in supplyOrders[type][level]:
				if averageAmount > order.amount:
					order.origin.AddIngredient(type, order.amount)
					resources[type] -= order.amount
					continue
				else:
					order.origin.AddIngredient(type, averageAmount)
					resources[type] -= averageAmount
					continue
					

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ProcessSupplyOrders()
	ClearSupplyOrders()
	

func PrintResourceStock():
	var output = ""
	for i in range(Enums.GOOD_TYPE_COUNT):
		output += Enums.GoodTypeToString(i) + ": " + str(resources[i]) + "  "
	return output


func ConsumeResource(type, amount) -> bool:
	if type == Enums.GoodType.None:
		return true
		
	if amount <= resources[type]:
		resources[type] -= amount
		#print("consumed " + Enums.GoodTypeToString(type) + " amount: " + str(amount))
		return true
	else:
		return false
		
		
func CheckResourceAvailable(type, amount) -> bool:
	if type == Enums.GoodType.None:
		return true
		
	if amount <= resources[type]:
		return true
	else:
		return false


func AddResource(type, amount):
	resources[type] += amount
