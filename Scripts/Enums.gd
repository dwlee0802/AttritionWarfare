class_name Enums

enum GoodType {Coal, Iron, Steel, Gun, Cannon, Engine, Ammunition, Infantry, Artillery, Armored, AntiTank, None}
static var GOOD_TYPE_COUNT: int = 7
static func GoodTypeToString(num):
	if num == 0:
		return "Coal"
	if num == 1:
		return "Iron"
	if num == 2:
		return "Steel"
	if num == 3:
		return "Gun"
	if num == 4:
		return "Cannon"
	if num == 5:
		return "Engine"
	if num == 6:
		return "Ammunition"
	
	return "None"

static func GoodTypeToIndustryName(num):
	if num == 0:
		return "Coal Mine"
	if num == 1:
		return "Iron Mine"
	if num == 2:
		return "Steel Mill"
	if num == 3:
		return "Gun Factory"
	if num == 4:
		return "Cannon Factory"
	if num == 5:
		return "Engine Factory"
	if num == 6:
		return "Ammunition Factory"
	
	return "None"

static func GoodTypeToDataPath(num):
	if num == 0:
		return "res://Data/Industry/coal_mine.tres"
	if num == 1:
		return "res://Data/Industry/iron_mine.tres"
	if num == 2:
		return "res://Data/Industry/steel_mill.tres"
	if num == 3:
		return "res://Data/Industry/gun_factory.tres"
	if num == 4:
		return "res://Data/Industry/cannon_factory.tres"
	if num == 5:
		return "res://Data/Industry/engine_factory.tres"
	if num == 6:
		return "res://Data/Industry/ammo_factory.tres"
	
	return null

enum IndustrySector {Basic, Processed, Manufactured, Recruitment}


enum UnitType {Infantry, Artillery, Armored, Antitank}
static var UNIT_TYPE_COUNT: int = 4
static func UnitTypeToString(num):
	if num == 0:
		return "Infantry"
	if num == 1:
		return "Artillery"
	if num == 2:
		return "Armored"
	if num == 3:
		return "Antitank"
	
	return "ERROR!"
	
static func UnitTypeToAbbString(num):
	if num == 0:
		return "Inf"
	if num == 1:
		return "Arty"
	if num == 2:
		return "Armd"
	if num == 3:
		return "AT"
	
	return "ERROR!"


enum OrderType {Offensive, Defensive, Retreat}


enum Direction {Up, Right, Left, Down}


enum BlockState {Player, Enemy, Neutral}


enum ModifierDataTypes {Terrain, Modifier, Infrastructure}

enum TerrainType {Plains, Hills, River, Mountain, None}

enum ModifierType {CoalDeposit, IronDeposit, None}

enum InfrastructureType {Road, Bridge, Tunnel, None}


static func ModifierTypeToString(num: TerrainType):
	if num == TerrainType.Plains:
		return "Plains"
	if num == TerrainType.Hills:
		return "Hills"
	if num == TerrainType.River:
		return "River"
	if num == TerrainType.Mountain:
		return "Mountain"
	
	return "None"
	
static func TerrainTypeToString(num: ModifierType):
	if num == ModifierType.CoalDeposit:
		return "CoalDeposit"
	if num == ModifierType.IronDeposit:
		return "IronDeposit"
	
	return "None"
	
static func InfrastructureTypeToString(num: InfrastructureType):
	if num == InfrastructureType.Road:
		return "Road"
	if num == InfrastructureType.Bridge:
		return "Bridge"
	if num == InfrastructureType.Tunnel:
		return "Tunnel"
	
	return "None"
