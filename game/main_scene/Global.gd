extends Node

#global mood variable is declared with setget
#whenever mood is changed outside of this node, setMood functionis called
var mood = 0 setget setMood;
var support_calming = false
var moodMultiplier = []

# list of all globally defined variables (all global variables are predetermined)
var var_list = ['mood', 'support_calming']

#declare signal mood_changed
signal mood_changed

#when the variable mood is changed, this function is called and emits the signal
func setMood(new_mood):
	mood = new_mood
	emit_signal("mood_changed", mood)

# return a dictionary of all the variables for use in yarn-importer
func get_dict():
	var dict = {}
	for var_name in var_list:
		dict[var_name] = get(var_name)
	return dict

