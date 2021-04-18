extends Control

const FADE_SPEED = 7

var target_opacity = 0
var minigame_shown = false
var minigame_name

signal exiting()
signal starting()

func _ready():
	modulate.a = 0
	hide()
	
func start_minigame(_minigame_name):
	for child in $Games.get_children():
		if child.name == _minigame_name:
			child.show()
			if child.has_method('start_minigame'):
				child.start_minigame()
		else:
			child.hide()
	
	# make all relevant nodes interactible 
	# (including the bg, which prevents input to the rest of the gui)
	set_mouse_filter_recursive(self, Control.MOUSE_FILTER_STOP)
	minigame_shown = true
	
	emit_signal('starting')
	show()
	target_opacity = 1
	minigame_name = _minigame_name
	
func end_minigame():
	target_opacity = 0
	emit_signal('exiting')
	for child in $Games.get_children():
		if child.name == minigame_name and child.has_method('end_minigame'):
			child.end_minigame()
	
	# make nodes not interactible, even while fadeout is still happening
	set_mouse_filter_recursive(self, Control.MOUSE_FILTER_IGNORE)
	minigame_shown = false

# for when the game resets
func end_minigame_immediately():
	target_opacity = 0
	modulate.a = 0
	hide()
	set_mouse_filter_recursive(self, Control.MOUSE_FILTER_IGNORE)
	minigame_shown = false

func set_mouse_filter_recursive(node, filter):
	# there's no way this is efficient... but... idk how else to do it...
	if 'mouse_filter' in node:
		node.mouse_filter = filter
		
	for child in node.get_children():
		set_mouse_filter_recursive(child, filter)
		
func _process(delta):
	modulate.a += (target_opacity - modulate.a) / 2 * delta * FADE_SPEED
	
	if target_opacity == 0 and modulate.a <= 0.001:
		modulate.a = 0
		hide()
	elif target_opacity == 1 and modulate.a >= 0.999:
		modulate.a = 1
	
