extends TextureProgress

#connects to the mood_changed signal
func _ready():
	Global.connect("mood_changed",self,"on_mood_change")

#When signal is recieved, value of progress value changes to current mood value
func on_mood_change(mood):
	self.value = int(mood)
	
	

	
