extends CheckButton

func _on_toggled(value):
	Settings.set("rakugo/game/text/scrolling_enabled", true)

func _on_visibility_changed():
	if visible:
		pressed = Settings.get("rakugo/game/text/scrolling_enabled")
