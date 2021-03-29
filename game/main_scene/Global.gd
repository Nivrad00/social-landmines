extends Node

#global mood variable is declared with setget
#whenever mood is changed outside of this node, setMood functionis called
var mood = 0 setget setMood;

#declare signal mood_changed
signal mood_changed

#when the variable mood is changed, this function is called and emits the signal
func setMood(new_mood):
	mood = new_mood
	emit_signal("mood_changed", mood)


