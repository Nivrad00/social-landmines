extends VBoxContainer


var mouseInSlider := false

func _input(event):
	if(mouseInSlider && Input.is_mouse_button_pressed(BUTTON_LEFT)):
		setValue($TextureRect2/TextureProgress)
		
func setValue(slider: TextureProgress):
	slider.value = ((1-ratioInBody(slider)) * slider.max_value)

func ratioInBody(slider: TextureProgress):
	var posClicked = get_local_mouse_position() - slider.rect_position
	var ratio = posClicked.y / slider.rect_size.y
	if(ratio > 1.0):
		ratio = 1.0
	elif(ratio < 0.0):
		ratio = 0.0
	return ratio
	
func _on_TextureProgress_mouse_entered():
	mouseInSlider = true
	
	
	
func _on_TextureProgress_mouse_exited():
	mouseInSlider = false
	
		
