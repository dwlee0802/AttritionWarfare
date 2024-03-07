extends Resource
class_name Terrain

@export var name: String = "Modifier Name Here"
# only one Terrain type can exist on a block
@export var icon: Texture2D = null
@export var type: Enums.TerrainType = Enums.TerrainType.None

@export var slotChange: int = 0
