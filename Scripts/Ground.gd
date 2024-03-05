extends HBoxContainer

var blocks = []

var blockScene = load("res://Scenes/block.tscn")

# how many blocks the map is made up of
@export var mapSize: int = 32

@export var randomFeatures: bool = true

@export var modifierOccurRate: float = 0

@export var baseCombatWidth: int = 5

const starting_blocks_count = 5


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
	
	for i in range(starting_blocks_count):
		blocks[i].captureState = Enums.BlockState.Player
		blocks[-i-1].captureState = Enums.BlockState.Enemy
		blocks[i].UpdateCaptureStateIndicator()
		blocks[-i-1].UpdateCaptureStateIndicator()
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
func GenerateMap():
	# clear children
	for child in get_children():
		child.queue_free()
		
	Block.baseCombatWidth = baseCombatWidth
	
	for i in range(mapSize):
		var newBlock: Block = blockScene.instantiate()
		blocks.append(newBlock)
		add_child(newBlock)
		
		# add terrain type modifier
		var rng = DataManager.terrainTypeData.keys().pick_random()
		newBlock.AddModifier(DataManager.terrainTypeData[rng])
		
		if randf() < modifierOccurRate:
			rng = DataManager.modifierData.keys().pick_random()
			newBlock.AddModifier(DataManager.modifierData[rng])
		
		
