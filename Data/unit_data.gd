extends Resource
class_name UnitData

@export var unitType: Enums.UnitType = Enums.UnitType.Infantry
@export var hitPoints: int = 100

@export var attackRange: int = 300
@export var minAttackRange: int = 0

# max number of blocks the unit can look for attack targets
@export var attackBlockRange: int = 1

@export var damageAmount: int = 10
# unit is attacks per second
@export var attackSpeed: float = 2

@export var speed: int = 100

@export var splashDamage: bool = false
@export var splashRange: int = 100

@export var indirectFire: bool = false

@export var supplyConsumptionType: Enums.GoodType = Enums.GoodType.None
@export var supplyConsumptionAmount: int = 0
@export var supplyConsumptionBaseTime: int = 1

@export var maintenanceAmount: int = 10

@export var defense: int = 0
@export var penetration: int = 0
