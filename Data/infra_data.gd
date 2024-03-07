extends Resource
class_name Infrastructure

@export var name: String = "Modifier Name Here"
# only one Terrain type can exist on a block
@export var icon: Texture2D = null
@export var type: Enums.InfrastructureType = Enums.InfrastructureType.None

# stats
@export var slotChange: int = 0
# optional variable for infrastructure modifiers
# if this is above 0, that means this is infrastructures
@export var cost: int = 0

# optianl variable for modifiers that can only be added if a certain type already exists
@export var requiresType: Enums.TerrainType = Enums.TerrainType.None

