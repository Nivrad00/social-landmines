extends Control

export var colors: PoolColorArray 

var pencil_cursor = load("res://graphics/draw_cursor.png")
var hover_style = load("res://themes/Default/ColoringBookButtonStyleHover.tres")
var normal_style = load("res://themes/Default/ColoringBookButtonStyleNormal.tres")
var pressed_style = load("res://themes/Default/ColoringBookButtonStylePressed.tres")

func _ready():
	Input.set_custom_mouse_cursor(pencil_cursor, Input.CURSOR_HELP)

	$ColorGrid/Button.pressed = true
	for i in range($ColorGrid.get_children().size()):
		if i < colors.size():
			var child = $ColorGrid.get_child(i)
			
			# set the color
			var color = colors[i]
			hover_style.bg_color = Color(color.r-0.1, color.g-0.1, color.b-0.1)
			normal_style.bg_color = color
			pressed_style.bg_color = color
			child.add_stylebox_override('normal', normal_style.duplicate())
			child.add_stylebox_override('hover', hover_style.duplicate())
			child.add_stylebox_override('pressed', pressed_style.duplicate())
			
			# connect the button
			child.connect('pressed', $DrawRegion, 'change_color', [color])
		
func start_minigame():
	$ColorGrid/Button.pressed = true
	$DrawRegion.enable()

func end_minigame():
	$DrawRegion.reset()
	$DrawRegion.disable()
