class_name Enums

enum GoodType {Coal, Iron, Steel, Gun, Cannon, Tank, None}
static var GOOD_TYPE_COUNT: int = 6
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


enum IndustrySector {Basic, Processed, Manufactured, Recruitment}

