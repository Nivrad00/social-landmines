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
	target = int(mood)
	$"../../AnimationPlayer".play('Glow')
	
func _process(delta):
	current += (target - current) / 2 * delta * SPEED
	value = current

	
