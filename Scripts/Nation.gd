extends Node
class_name Nation

@export var resources = [0, 0, 0, 0, 0, 0, 0]
@export var stockMax = [50, 50, 50, 50, 50, 50, 50]
var industries = []

@export var hq: HQ

# supply order system
# 3D array of supply orders
# first index is the good type of the request
# second index is the priority levels of the request
# third is the actual order
var supplyOrders = []
const MAX_PRIORITY_LEVEL: int = 10

var funds: float = 1000
var revenuePerSecond: float = 100


# Called when the node enters the scene tree for the first time.
func _ready():
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
			if len(supplyOrders[type][MAX_PRIORITY_LEVEL - level - 1]) == 0:
				continue
				
			var averageAmount: float = resources[type] / len(supplyOrders[type][MAX_PRIORITY_LEVEL - level - 1])
			for order: SupplyOrder in supplyOrders[type][MAX_PRIORITY_LEVEL - level - 1]:
				if !is_instance_valid(order.origin):
					continue
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
	funds += delta * revenuePerSecond
	
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


func CheckStockSpace(type, amount = 0) -> bool:
	if resources[type] + amount <= stockMax[type]:
		return true
	else:
		return false


func AddResource(type, amount):
	resources[type] += amount
	
	if resources[type] > stockMax[type]:
		resources[type] = stockMax[type]
		

func CheckEnoughFunds(amount):
	return amount <= funds
	
	
func ChangeFunds(amount: int = 0):
	funds += amount
	if funds < 0:
		funds = 0
