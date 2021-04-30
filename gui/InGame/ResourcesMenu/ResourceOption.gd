extends Panel

export var resource_name = ''
export var button_text = ''

func _ready():
	$Button.text = button_text
	
func connect_button(in_game_gui):
	$Button.connect('pressed', in_game_gui, '_on_resource_button_press', [resource_name])
