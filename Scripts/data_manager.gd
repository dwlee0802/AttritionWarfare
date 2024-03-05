extends Node

static var modifierData = {}
static var MODIFIER_COUNT: int = 5

static var terrainTypeData = {}
static var TERRAIN_COUNT: int = 4

static func _static_init():
	modifierData[Enums.ModifierType.Bridge] = load("res://Data/Modifiers/bridge.tres")
	modifierData[Enums.ModifierType.CoalDeposit] = load("res://Data/Modifiers/coal_deposit.tres")
	modifierData[Enums.ModifierType.IronDeposit] = load("res://Data/Modifiers/iron_deposit.tres")
	modifierData[Enums.ModifierType.Road] = load("res://Data/Modifiers/road.tres")
	modifierData[Enums.ModifierType.Tunnel] = load("res://Data/Modifiers/tunnel.tres")
	
	terrainTypeData[Enums.ModifierType.Hills] = load("res://Data/Modifiers/hills.tres")
	terrainTypeData[Enums.ModifierType.Mountain] = load("res://Data/Modifiers/mountain.tres")
	terrainTypeData[Enums.ModifierType.Plains] = load("res://Data/Modifiers/plains.tres")
	terrainTypeData[Enums.ModifierType.River] = load("res://Data/Modifiers/river.tres")
