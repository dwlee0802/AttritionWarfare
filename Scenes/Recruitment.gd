extends Industry

@export var unitType: Enums.UnitType

func Production():
	get_parent().get_parent().hq.SpawnUnit(unitType)
