class_name Enums

enum GoodType {Coal, Iron, Steel, Gun, Cannon, Tank, Ammunition, Infantry, Artillery, Armored, AntiTank, None}
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
		return "Tank"
	if num == 6:
		return "Ammunition"


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
