class_name Industry

enum ProductionType {InfantryEquipment, Artillery, Armored, AntiTank}
const TYPE_COUNT = 4

var stock = [0, 0, 0, 0]

var factoryAssignment = [0, 0, 0, 0]

var productionPerFactory = [100, 10, 10, 10]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Production(delta):
	for i in range(TYPE_COUNT):
		stock[i] += factoryAssignment[i] * productionPerFactory[i] * delta
