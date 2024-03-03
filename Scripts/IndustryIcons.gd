extends VBoxContainer
class_name IndustryIcons

@onready var buildButton = $BuildButton

@onready var typeButtons = $BuildButton/TypeButtons

@onready var industryButtons = $BuildButton/BuildOptions/Industry
@onready var infraButtons = $BuildButton/BuildOptions/Infrastructure

var block: Block


# Called when the node enters the scene tree for the first time.
func _ready():
	block = get_parent().get_parent()
	Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if buildButton.button_pressed == false:
		Reset()
	

func _on_build_button_toggled(toggled_on):
	typeButtons.visible = toggled_on


func _on_type_button_pressed(is_industry):
	typeButtons.visible = false
	
	if is_industry:
		industryButtons.visible = true
	else:
		infraButtons.visible = true


func Reset():
	buildButton.button_pressed = false
	typeButtons.visible = false
	industryButtons.visible = false
	infraButtons.visible = false
