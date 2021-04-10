extends Control

signal faded_in()
			
func start_minigame(minigame_name):
	for child in $Games.get_children():
		if child.name == minigame_name:
			child.show()
		else:
			child.hide()
	show()
	$AnimationPlayer.play('Fade In')
	yield($AnimationPlayer, 'animation_finished')
	emit_signal('faded_in')

func end_minigame():
	$AnimationPlayer.play('Fade Out')
	yield($AnimationPlayer, 'animation_finished')
	hide()
	
