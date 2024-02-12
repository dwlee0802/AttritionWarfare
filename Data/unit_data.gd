extends Resource
class_name UnitData

@export var unitType: Enums.UnitType = Enums.UnitType.Infantry
@export var hitPoints: int = 100

@export var attackRange: int = 300
@export var minAttackRange: int = 0

@export var minDamage: int = 20
@export var maxDamage: int = 40
@export var attackSpeed: float = 1

@export var speed: int = 100

@export var splashDamage: bool = false
@export var splashRange: int = 100

@export var indirectFire: bool = false

@export var supplyConsumptionType: Enums.GoodType = Enums.GoodType.None
@export var supplyConsumptionAmount: int = 0
