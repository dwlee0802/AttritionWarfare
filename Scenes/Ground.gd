extends HBoxContainer

var blocks = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for block: Block in get_children():
		blocks.append(block)
	
	for i in range(len(blocks)):
		# set prev
		if i >= 1:
			blocks[i].prevBlock = blocks[i - 1]
		
		# set next
		if i + 1 < len(blocks):
			blocks[i].nextBlock = blocks[i + 1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
