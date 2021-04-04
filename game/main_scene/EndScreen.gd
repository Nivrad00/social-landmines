extends Control

signal show_main_menu(s)
var shown = 0

func _ready():
	hide()
	for child in $Container.get_children():
		child.modulate.a = 0

func _on_end_game():
	show()
	add_line()
	yield($Container/Button, 'pressed')
	Rakugo.reset_game()
	Window.Screens._on_nav_button_press('main_menu')

func add_line():
	print(shown)
	if shown >= $Container.get_children().size():
		return
	
	else:
		var next_line = $Container.get_child(shown)
		if next_line is Button:
			next_line.disabled = false
		next_line.get_node('AnimationPlayer').play('Fade In')
		shown += 1
		$FadeInTimer.start()
	
