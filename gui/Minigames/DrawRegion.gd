extends Control

signal drew_line(prev, current)

var enabled = false
var prev_mouse_pos = null
var coloring_page_path = 'res://gui/Minigames/ColoringPages/'
var coloring_page_names = []

func _ready():
	randomize()
	$DrawTexture.set_texture($DrawViewport.get_texture())
	
	var dir = Directory.new()
	if dir.open(coloring_page_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var extension = file_name.split('.')[-1]
			if extension in ['jpg', 'png']:
				coloring_page_names.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occured while trying to access the coloring pages.")
		
	reset()
	
func disable():
	prev_mouse_pos = null
	enabled = false
	$ColoringPage.mouse_default_cursor_shape = Input.CURSOR_ARROW
	hide()

func enable():
	enabled = true
	$ColoringPage.mouse_default_cursor_shape = Input.CURSOR_HELP
	show()

func reset():
	# get new coloring page
	var random_page_name = coloring_page_names[randi() % coloring_page_names.size()]
	$ColoringPage.texture = load(coloring_page_path + random_page_name)
	
	# erase drawing
	$DrawViewport/Pen.to_erase = true
	
	# reset color
	$DrawViewport/Pen.color = get_parent().colors[0]

func change_color(color):
	$DrawViewport/Pen.color = color
	
func _input(input):
	if not enabled:
		return
		
	elif input is InputEventMouseMotion:
		var current_mouse_pos = input.position - rect_position
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and prev_mouse_pos:
			emit_signal('drew_line', prev_mouse_pos, current_mouse_pos)
			$DrawViewport/Pen.to_draw = [prev_mouse_pos, current_mouse_pos]
			
		prev_mouse_pos = current_mouse_pos
		
	elif input is InputEventMouseButton and input.pressed and input.button_index == BUTTON_LEFT:
		var current_mouse_pos = input.position - rect_position
		emit_signal('drew_line', null, current_mouse_pos)
		$DrawViewport/Pen.to_draw = [null, current_mouse_pos]
		prev_mouse_pos = current_mouse_pos
			
	
func _process(delta):
	update()
