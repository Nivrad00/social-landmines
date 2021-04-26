extends Control

var state = 0

func _ready():
	pass

func set_dialogue(text):
	$Controls/Dialogue/MarginContainer/VBoxContainer/message.text = text

func start_minigame():
	state = 0
	$Controls/Options.hide()
	set_dialogue("Hello! Would you like to join me for a guided meditation?")


func end_minigame():
	$meditation_audio.stop()

func _on_Button_pressed():
	state = 2
	$Controls/Options.hide()
	set_dialogue("Okay, let's begin.")
	yield(get_tree().create_timer(1),"timeout")
	$meditation_audio.play()
	yield(get_tree().create_timer(1),"timeout")
	set_dialogue("")

func _on_Button2_pressed():
	$Controls/Options.hide()
	set_dialogue("Okay, how about you try another coping tactic?")


func _input(input):
	if state == 0 and visible and input is InputEventMouseButton and input.pressed and input.button_index == BUTTON_LEFT:
		$Controls/Options.show()
		state = 1


func _on_meditation_audio_finished():
	set_dialogue("Good job getting through the meditation!")
	Global.mood = Global.mood - 15
