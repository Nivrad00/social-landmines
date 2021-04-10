extends Panel

export var resource_name = ''
export var button_text = ''
export var button_icon: Texture = null

func _ready():
	$Button.text = button_text
	$TextureRect.texture = button_icon
	
func connect_button(in_game_gui):
	$Button.connect('pressed', in_game_gui, '_on_resource_button_press', [resource_name])
