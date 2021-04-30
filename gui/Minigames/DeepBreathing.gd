extends Control

func start_minigame():
	$AnimationPlayer.play("Grow")

func end_minigame():
	$AnimationPlayer.stop()
