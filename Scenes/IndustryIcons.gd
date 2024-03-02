extends VBoxContainer

@onready var typeButtons = $BuildButton/TypeButtons

@onready var industryButtons = $BuildButton/BuildOptions/Industry
@onready var infraButtons = $BuildButton/BuildOptions/Infrastructure


# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectBuildSignals()
	Reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_build_button_toggled(toggled_on):
	typeButtons.visible = toggled_on
	if toggled_on == false:
		Reset()


func _on_type_button_pressed(is_industry):
	typeButtons.visible = false
	
	if is_industry:
		industryButtons.visible = true
	else:
		infraButtons.visible = true


func Reset():
	$BuildButton.button_pressed = false
	typeButtons.visible = false
	industryButtons.visible = false
	infraButtons.visible = false
	

func _on_industry_button_pressed(extra_arg_0):
	print(Enums.GoodTypeToString(extra_arg_0))
	Reset()


func ConnectBuildSignals():
	for child in industryButtons.get_children():
		if child is BuildTypeButton:
			child.pressed.connect(_on_industry_button_pressed.bind(child.goodType))
