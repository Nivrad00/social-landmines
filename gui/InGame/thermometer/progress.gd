extends TextureProgress

var target = 0
var current = 0
const SPEED = 4

#connects to the mood_changed signal
func _ready():
	set_process(true)
	Global.connect("mood_changed",self,"on_mood_change")

#When signal is recieved, value of progress value changes to current mood value
func on_mood_change(mood):
	print('changing mood to ' + str(mood))
	if mood != null and mood != target:
		$"../../AnimationPlayer".play('Glow')
		if mood > target:
			$"../../Arrow/AnimationPlayer".play('Up')
		if mood < target:
			$"../../Arrow/AnimationPlayer".play('Down')
		target = int(mood)
	
func _process(delta):
	current += (target - current) / 2 * delta * SPEED
	value = current

	
