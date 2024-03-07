extends Node

static var terrainData = {}
static var modifierData = {}
static var infraData = {}

static func _static_init():
	modifierData[Enums.ModifierType.CoalDeposit] = load("res://Data/Modifiers/Modifiers/coal_deposit.tres")
	modifierData[Enums.ModifierType.IronDeposit] = load("res://Data/Modifiers/Modifiers/iron_deposit.tres")
	
	# infra types
	infraData[Enums.InfrastructureType.Road] = load("res://Data/Modifiers/Infrastructure/bridge.tres")
	infraData[Enums.InfrastructureType.Tunnel] = load("res://Data/Modifiers/Infrastructure/bridge.tres")
	infraData[Enums.InfrastructureType.Bridge] = load("res://Data/Modifiers/Infrastructure/tunnel.tres")
	
	# terrain types
	terrainData[Enums.TerrainType.Hills] = load("res://Data/Modifiers/Terrain/hills.tres")
	terrainData[Enums.TerrainType.Mountain] = load("res://Data/Modifiers/Terrain/mountain.tres")
	terrainData[Enums.TerrainType.Plains] = load("res://Data/Modifiers/Terrain/plains.tres")
	terrainData[Enums.TerrainType.River] = load("res://Data/Modifiers/Terrain/river.tres")
