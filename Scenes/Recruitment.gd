extends Industry


func Production():
	get_parent().get_parent().hq.SpawnUnit(productionType)
