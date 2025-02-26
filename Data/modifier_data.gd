extends Resource
class_name Modifier

@export var name: String = "Modifier Name Here"
# only one Terrain type can exist on a block
@export var icon: Texture2D = null
@export var type: Enums.ModifierType = Enums.ModifierType.None

# stats
@export var slotChange: int = 0

@export var coalDeposit: bool = false
@export var ironDeposit: bool = false
