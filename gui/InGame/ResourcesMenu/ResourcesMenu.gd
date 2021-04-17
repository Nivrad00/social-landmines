extends VBoxContainer

signal opened()

var dropdown_shown = false
var target_pos = 0
var target_opacity = 0

onready var caret = $Tab/Panel/Caret
onready var resource_container = $Content/MarginContainer/VBoxContainer
onready var bg = get_parent().get_node('ResourcesMenuBG')

const DROPDOWN_SPEED = 10

func _ready():
	target_pos = hidden_pos()
	rect_position.y = target_pos
	bg.modulate.a = target_opacity
	bg.hide()
	
	# connect all the buttons
	for child in resource_container.get_children():
		child.connect_button(get_parent())

# the y position at which the content is hidden, but not the tab
func hidden_pos():
	return -$Tab.rect_position.y * rect_scale.y
	
func toggle_dropdown():
	if dropdown_shown:
		target_pos = hidden_pos()
		target_opacity = 0
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dropdown_shown = false
		caret.flip_v = false
		
	else:
		target_pos = 0
		target_opacity = 1
		bg.show()
		bg.mouse_filter = Control.MOUSE_FILTER_STOP
		dropdown_shown = true
		caret.flip_v = true
		emit_signal('opened')

# for when the game resets or when a minigame ends
func hide_dropdown_immediately():
	if dropdown_shown:
		target_pos = hidden_pos()
		target_opacity = 0
		rect_position.y = target_pos
		bg.modulate.a = target_opacity
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dropdown_shown = false
		caret.flip_v = false
		
func _process(delta):
	rect_position.y += (target_pos - rect_position.y) / 2 * delta * DROPDOWN_SPEED
	bg.modulate.a += (target_opacity - bg.modulate.a) / 2 * delta * DROPDOWN_SPEED
	
	if target_opacity == 0 and bg.modulate.a <= 0.001:
		bg.modulate.a = 0
		bg.hide()
	elif target_opacity == 1 and bg.modulate.a >= 0.999:
		bg.modulate.a = 1
