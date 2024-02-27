extends Control
class_name IndustrySlot

var neighborSlots = {}

@onready var bonusLabel: Label = $BonusLabel

# bonus to production cycle speed for industry in this slot
var bonus_speed: float = 0

# emitted when new block is received
signal block_changed

var _data


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	UpdateBonuses()


func UpdateBonuses():
	bonusLabel.text = ""
	if bonus_speed > 0:
		bonusLabel.text = "+" + str(int(bonus_speed * 100)) + "%"
	elif bonus_speed < 0:
		bonus_speed = 0
		print("ERROR! Bonus shouldn't be below zero")
	
	
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is IndustryBlock:
		return true
		
	return false


# receive new block at this position
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# remove old parent's neighbors' bonuses
	if data.get_parent() is IndustrySlot:
		for key in data.get_parent().neighborSlots.keys():
			neighborSlots[key].bonus_speed -= data.industry.bonusAmount
			if neighborSlots[key].bonus_speed < 0:
				print("ERROR bonus shouldnt go below zero")
				neighborSlots[key].bonus_speed = 0
			
	data.get_parent().remove_child(data)
	
	# add it as a sibling so that label is lower
	get_child(0).add_sibling(data)
	data.position = Vector2.ZERO

	# add bonus to new parent's neighbors
	for key in neighborSlots.keys():
		neighborSlots[key].bonus_speed += data.industry.bonusAmount
	
	_data = data
	

func RemoveBonus():
	if _data == null:
		return
		
	for key in neighborSlots.keys():
		neighborSlots[key].bonus_speed -= _data.industry.bonusAmount
		_data = null
