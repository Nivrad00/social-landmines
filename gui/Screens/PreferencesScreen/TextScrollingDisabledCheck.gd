extends CheckButton

func _on_toggled(value):
	Settings.set("rakugo/game/text/scrolling_enabled", false)

func _on_visibility_changed():
	if visible:
		pressed = !Settings.get("rakugo/game/text/scrolling_enabled")
