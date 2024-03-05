extends Resource
class_name Modifier

@export var name: String = "Modifier Name Here"
@export var icon: Texture2D = null

# optional variable for infrastructure modifiers
# if this is above 0, that means this is infrastructures
@export var cost: int = 0

@export var slotChange: int = 0
@export var coalDeposit: bool = false
@export var ironDeposit: bool = false
