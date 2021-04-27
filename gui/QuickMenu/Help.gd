extends Button


signal help_pressed

func _on_Help_pressed():
	emit_signal("help_pressed")
