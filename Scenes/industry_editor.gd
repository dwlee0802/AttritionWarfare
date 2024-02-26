extends Panel
class_name IndustryEditor

var industryBlockScene = load("res://Scenes/industry_block.tscn")

@onready var grid = $Editor/Grid
@onready var deck = $Editor/Deck


# Called when the node enters the scene tree for the first time.
func _ready():
	LinkNeighbors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func AddIndustryBlock(data: Industry):
	var newBlock: IndustryBlock = industryBlockScene.instantiate()
	newBlock.industry = data
	
	deck.add_child(newBlock)
	
	
func LinkNeighbors():
	var target: IndustrySlot
	for i in range(grid.get_child_count()):
		# up
		if i - 7 >= 0:
			grid.get_child(i).neighborSlots[Enums.Direction.Up] = grid.get_child(i - 7)
		# down
		if i + 7 < grid.get_child_count():
			grid.get_child(i).neighborSlots[Enums.Direction.Down] = grid.get_child(i + 7)
		# left
		if i - 1 >= 0:
			grid.get_child(i).neighborSlots[Enums.Direction.Left] = grid.get_child(i - 1)
		# right
		if i + 1 < grid.get_child_count():
			grid.get_child(i).neighborSlots[Enums.Direction.Right] = grid.get_child(i + 1)
