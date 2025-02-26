extends Control
class_name IndustryBlock

@export var industry: Industry

@onready var progressShade = $ProgressShade

@onready var levelLabel: Label = $LevelLabel

@onready var tempGoodLabel: Label = $ProducedGoodIcon/TempGoodLabel

# ingredients
@onready var ingredient_1 = $IngredientsContainer/Ingredient_1
@onready var ingredient_1_shade = $IngredientsContainer/Ingredient_1/ProgressShade
@onready var ingredient_2 = $IngredientsContainer/Ingredient_2
@onready var ingredient_2_shade = $IngredientsContainer/Ingredient_2/ProgressShade
@onready var ingredient_3 = $IngredientsContainer/Ingredient_3
@onready var ingredient_3_shade = $IngredientsContainer/Ingredient_3/ProgressShade


# Called when the node enters the scene tree for the first time.
func _ready():
	UpdateGoodType()
	UpdateIngredientType()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	UpdateProgressShade(industry.productionTimer.time_left / industry.productionTimer.wait_time)
	UpdateLevel()
	UpdateIngredientAmount()
	UpdateGoodType()
	ApplyBonus()
	
	industry.active = get_parent() is IndustrySlot
		

func UpdateProgressShade(ratio):
	progressShade.anchor_bottom = ratio


func UpdateLevel():
	if industry == null:
		return
		
	levelLabel.text = "Lv. " + str(industry.level)
	
	
func UpdateGoodType():
	if industry == null:
		return
		
	tempGoodLabel.text = Enums.GoodTypeToString(industry.productionType) + " (" + str(int(industry.productionTimer.time_left * 10) * 0.1) + "s)"


# change the ingredient icons to show ingredient type
func UpdateIngredientType():
	if industry.ingredientType0 != Enums.GoodType.None:
		ingredient_1.get_node("TempGoodLabel").text = Enums.GoodTypeToString(industry.ingredientType0)
	else:
		ingredient_1.visible = false
		
	if industry.ingredientType1 != Enums.GoodType.None:
		ingredient_2.get_node("TempGoodLabel").text = Enums.GoodTypeToString(industry.ingredientType1)
	else:
		ingredient_2.visible = false
		
	if industry.ingredientType2 != Enums.GoodType.None:
		ingredient_3.get_node("TempGoodLabel").text = Enums.GoodTypeToString(industry.ingredientType2)
	else:
		ingredient_3.visible = false
	

# change the ingredient icons progress shade to show got amount
func UpdateIngredientAmount():
	if industry.ingredientType0 != Enums.GoodType.None:
		ingredient_1_shade.anchor_bottom = 1 - industry.ingredientType0_Received / industry.ingredientType0_Amount
		
	if industry.ingredientType1 != Enums.GoodType.None:
		ingredient_2_shade.anchor_bottom = 1 - industry.ingredientType1_Received / industry.ingredientType1_Amount
		
	if industry.ingredientType2 != Enums.GoodType.None:
		ingredient_3_shade.anchor_bottom = 1 - industry.ingredientType2_Received / industry.ingredientType2_Amount


# Drag n Drop stuff
func _get_drag_data(_at_position: Vector2) -> Variant:
	set_drag_preview(make_drag_preview())
	return self
	
	
func make_drag_preview() -> TextureRect:
	var t = TextureRect.new()
	t.texture = $Background.texture
	t.custom_minimum_size = size
	
	var icon = TextureRect.new()
	var goodIcon: TextureRect = $ProducedGoodIcon
	icon.self_modulate = goodIcon.self_modulate
	icon.texture = goodIcon.texture
	icon.custom_minimum_size = goodIcon.size
	icon.anchor_left = goodIcon.anchor_left
	icon.anchor_top = goodIcon.anchor_top
	
	var label = Label.new()
	icon.add_child(label)
	label.text = $ProducedGoodIcon/TempGoodLabel.text
	label.theme = $ProducedGoodIcon/TempGoodLabel.theme
	label.anchors_preset = PRESET_FULL_RECT
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.self_modulate = Color.BLACK
	
	t.position = Camera.pos
	
	t.add_child(icon)
	
	return t


# return true for swapping
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is IndustryBlock:
		return true
		
	return false


# swap positions with new block
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data == self:
		return
		
	# remove old parent's neighbors' bonuses
	var parent = get_parent()
	var theirParent = data.get_parent()
	
	# swap bonuses for their parent
	if theirParent is IndustrySlot:
		for key in theirParent.neighborSlots.keys():
			theirParent.neighborSlots[key].bonus_speed += industry.bonusAmount
			theirParent.neighborSlots[key].bonus_speed -= data.industry.bonusAmount
			
	# for our parent
	if parent is IndustrySlot:
		for key in parent.neighborSlots.keys():
			parent.neighborSlots[key].bonus_speed -= industry.bonusAmount
			parent.neighborSlots[key].bonus_speed += data.industry.bonusAmount
	
	# decoupling
	parent.remove_child(self)	
	theirParent.remove_child(data)
	
	# swap children
	if theirParent is IndustrySlot:
		theirParent.get_child(0).add_sibling(self)
		theirParent._data = self
	else:
		theirParent.add_child(self)
		
	if parent is IndustrySlot:
		parent.get_child(0).add_sibling(data)
		parent._data = data
	else:
		parent.add_child(data)
	
	position = Vector2.ZERO
	data.position = Vector2.ZERO
	
	
func ApplyBonus():
	var parent = get_parent()
	if parent is IndustrySlot:
		industry.receivedBonusAmount = parent.bonus_speed
