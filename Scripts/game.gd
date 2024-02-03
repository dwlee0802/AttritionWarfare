extends Control
class_name Game

static var playerNation: Nation

static var deathEffect = preload("res://Scenes/death_effect.tscn")

static var gameInstance: Game


# Called when the node enters the scene tree for the first time.
func _ready():
	self.playerNation = $PlayerNation
	self.gameInstance = self
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


static func MakeDeathEffect(where):
	var newEff = deathEffect.instantiate()
	newEff.global_position = where
	gameInstance.add_child(newEff)
