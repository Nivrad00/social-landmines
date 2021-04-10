extends VBoxContainer

var dropdown_shown = false
var target_height = 0

onready var caret = $Tab/Panel/Caret

const DROPDOWN_SPEED = 10

# the height at which the content is hidden, but not the tab
func hidden_height():
	return -$Tab.rect_position.y * rect_scale.y
	
func _ready():
	target_height = hidden_height()
	rect_position.y = target_height

func toggle_dropdown():
	if dropdown_shown:
		target_height = hidden_height()
		dropdown_shown = false
		caret.flip_v = false
		
	else:
		target_height = 0
		dropdown_shown = true
		caret.flip_v = true

func _process(delta):
	rect_position.y += (target_height - rect_position.y) / 2 * delta * DROPDOWN_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
