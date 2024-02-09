extends Node
class_name Nation

@export var resources = [0, 0, 0, 0, 0, 0, 0]
@export var stockMax = [100, 100, 100, 100, 100, 100, 100]
var industries = []

@export var hq: HQ


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in get_node("Industry").get_children():
		industries.append(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
	if amount <= resources[type]:
		return true
	else:
		return false


func AddResource(type, amount):
	resources[type] += amount
