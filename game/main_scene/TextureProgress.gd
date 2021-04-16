extends TextureProgress



func _on_HSlider_value_changed(value):
	self.value = value*10
