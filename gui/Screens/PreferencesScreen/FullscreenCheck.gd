extends CheckButton


func _ready():
	get_tree().get_root().connect("size_changed", self, "_on_window_resized")


func _on_toggled(value):
	if value:
		OS.window_fullscreen = true


func _on_visibility_changed():
	pressed = OS.window_fullscreen


func _on_window_resized():
	pressed = OS.window_fullscreen
