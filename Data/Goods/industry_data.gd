extends Resource
class_name IndustryData

@export var productionType: Enums.GoodType = Enums.GoodType.None
@export var industrySector: Enums.IndustrySector = Enums.IndustrySector.Basic
@export var baseProductionTime: float = 1
@export var productionAmount: int = 0


@export var ingredientType0: Enums.GoodType = Enums.GoodType.None
@export var ingredientType0_Need: int = 0

# how much bonus this gives to its neighbors
var bonusAmount: float = 0.1
