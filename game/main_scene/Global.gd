extends Node

signal mood_changed

var moodMultiplier = []

# contains all global variables
var var_dict = {}

func set_var(key, value):
	var_dict[key] = value
	if key == 'mood':
		emit_signal("mood_changed", value)
		
func get_var(key):
	if key in var_dict:
		return var_dict[key]
	else:
		return null
	
func get_dict():
	return var_dict

