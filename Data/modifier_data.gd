extends Resource
class_name Modifier

@export var name: String = "Modifier Name Here"
# only one Terrain type can exist on a block
@export var isTerrain: bool = false
@export var icon: Texture2D = null
@export var type: Enums.ModifierType = Enums.ModifierType.None

# optional variable for infrastructure modifiers
# if this is above 0, that means this is infrastructures
@export var cost: int = 0

# optianl variable for modifiers that can only be added if a certain type already exists
@export var requiresType: Enums.ModifierType = Enums.ModifierType.None

@export var slotChange: int = 0
@export var coalDeposit: bool = false
@export var ironDeposit: bool = false
