extends Control
class_name Game

static var playerNation: Nation


# Called when the node enters the scene tree for the first time.
func _ready():
	self.playerNation = $PlayerNation
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
