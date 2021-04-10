extends VBoxContainer

var dropdown_shown = false
var target_pos = 0

onready var caret = $Tab/Panel/Caret
onready var resource_container = $Content/MarginContainer/VBoxContainer

const DROPDOWN_SPEED = 10

func _ready():
	target_pos = hidden_pos()
	rect_position.y = target_pos
	
	# connect all the buttons
	for child in resource_container.get_children():
		child.connect_button(get_parent())

# the y position at which the content is hidden, but not the tab
func hidden_pos():
	return -$Tab.rect_position.y * rect_scale.y
	
func toggle_dropdown():
	if dropdown_shown:
		target_pos = hidden_pos()
		dropdown_shown = false
		caret.flip_v = false
		
	else:
		target_pos = 0
		dropdown_shown = true
		caret.flip_v = true
	
func _process(delta):
	rect_position.y += (target_pos - rect_position.y) / 2 * delta * DROPDOWN_SPEED
