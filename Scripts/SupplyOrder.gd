class_name SupplyOrder

# who submitted this supply order
# supply priority is included here
var origin: Industry

# what is being requested
var goodType: Enums.GoodType = Enums.GoodType.None

# how much is being requested
var amount: float = 0


func _init(who, what: Enums.GoodType, much: float):
	origin = who
	goodType = what
	amount = much
