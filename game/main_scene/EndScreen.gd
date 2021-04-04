extends Control

signal show_main_menu(s)

func _on_end_game():
	print('still ending game;....')
	show()
	yield($Button, 'pressed')
	Rakugo.reset_game()
	Window.Screens._on_nav_button_press('main_menu')
