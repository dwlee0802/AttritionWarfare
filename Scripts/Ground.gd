extends HBoxContainer

var blocks = []

var blockScene = load("res://Scenes/block.tscn")

# how many blocks the map is made up of
@export var mapSize: int = 32

@export var randomFeatures: bool = true

@export var baseCombatWidth: int = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	GenerateMap()

	for i in range(len(blocks)):
		# set prev
		if i >= 1:
			blocks[i].prevBlock = blocks[i - 1]
		
		# set next
		if i + 1 < len(blocks):
			blocks[i].nextBlock = blocks[i + 1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func GenerateMap():
	# clear children
	for child in get_children():
		child.queue_free()
		
	Block.baseCombatWidth = baseCombatWidth
	
	for i in range(mapSize):
		var newBlock = blockScene.instantiate()
		blocks.append(newBlock)
		add_child(newBlock)
