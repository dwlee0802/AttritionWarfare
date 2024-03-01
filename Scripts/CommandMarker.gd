extends CharacterBody2D
class_name CommandMarker

static var location: float
static var locationDict = {
	Enums.UnitType.Infantry: 0,
	Enums.UnitType.Artillery: 0,
	Enums.UnitType.Armored: 0,
	Enums.UnitType.Antitank: 0}
	
@export var isAllCommand: bool = false
@export var type: Enums.UnitType = Enums.UnitType.Infantry

@onready var highlightSprite: Sprite2D = $HighlightSprite


func _ready():
	if isAllCommand:
		$Sprite2D/Sprite2D.self_modulate = Color.REBECCA_PURPLE
	elif type == Enums.UnitType.Infantry:
		$Sprite2D/Sprite2D.self_modulate = Color.DARK_OLIVE_GREEN
	elif type == Enums.UnitType.Artillery:
		$Sprite2D/Sprite2D.self_modulate = Color.DARK_RED
	elif type == Enums.UnitType.Armored:
		$Sprite2D/Sprite2D.self_modulate = Color.DIM_GRAY
	elif type == Enums.UnitType.Antitank:
		$Sprite2D/Sprite2D.self_modulate = Color.DARK_ORANGE
		
		
func _physics_process(_delta):
	if OrderTab.selectedType == type and Input.is_action_pressed("right_click"):
		global_position = get_global_mouse_position()
	else:
		velocity = Vector2(0, 20)
		var collision = move_and_collide(velocity)
		if collision != null:
			var block = collision.get_collider()
			global_position = Vector2(block.global_position.x, global_position.y)
		
	
	if isAllCommand:
		CommandMarker.location = global_position.x
	else:
		locationDict[type] = global_position.x
	
	highlightSprite.visible = (OrderTab.selectedType == type)
