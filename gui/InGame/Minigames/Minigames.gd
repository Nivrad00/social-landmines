extends Control

const FADE_SPEED = 7

var target_opacity = 0

signal exiting()
signal faded_in()

func _ready():
	modulate.a = 0
	hide()
	
func start_minigame(minigame_name):
	for child in $Games.get_children():
		if child.name == minigame_name:
			child.show()
		else:
			child.hide()
	
	# make all relevant nodes interactible 
	# (including the bg, which prevents input to the rest of the gui)
	set_mouse_filter_recursive(self, Control.MOUSE_FILTER_STOP)
	
	show()
	target_opacity = 1
	
func end_minigame():
	target_opacity = 0
	emit_signal('exiting')
	
	# make nodes not interactible, even while fadeout is still happening
	set_mouse_filter_recursive(self, Control.MOUSE_FILTER_IGNORE)

func set_mouse_filter_recursive(node, filter):
	# there's no way this is efficient... but... idk how else to do it...
	if 'mouse_filter' in node:
		node.mouse_filter = filter
		
	for child in node.get_children():
		set_mouse_filter_recursive(child, filter)
		
func _process(delta):
	modulate.a += (target_opacity - modulate.a) / 2 * delta * FADE_SPEED
	
	if target_opacity == 0 and modulate.a <= 0.001:
		modulate.a == 0
		hide()
	elif target_opacity == 1 and modulate.a >= 0.999:
		modulate.a == 1
		emit_signal('faded_in')
	
