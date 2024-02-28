extends Control
class_name Game

static var playerNation: Nation
static var enemyNation: Nation

static var deathEffect = preload("res://Scenes/death_effect.tscn")

static var damagePopup = preload("res://Scenes/damage_popup.tscn")

static var gameInstance: Game

static var gameWorld: World


# Called when the node enters the scene tree for the first time.
func _ready():
	self.playerNation = $PlayerNation
	self.enemyNation = $EnemyNation
	self.gameInstance = self
	gameWorld = $World
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


static func MakeDeathEffect(where):
	if gameInstance == null:
		return
		
	var newEff = deathEffect.instantiate()
	newEff.global_position = where
	gameInstance.add_child(newEff)


static func MakeDamagePopup(text, where, color = Color.RED):
	var newPopup = damagePopup.instantiate()
	newPopup.get_node("Label").text = text
	newPopup.modulate = color
	newPopup.global_position = where
	gameWorld.add_child(newPopup)
