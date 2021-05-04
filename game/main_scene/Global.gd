extends Node

signal mood_changed

var moodMultiplier = []

# contains all global variables
var var_dict = {}

func set_var(key, value):
	var_dict[key] = value
	Rakugo.store.set(key,value)
	if key == 'mood':
		if not var_dict.has('original_mood'):
			set_var('original_mood',value)
		emit_signal("mood_changed", value)
		
func get_var(key):
	if key in var_dict:
		return var_dict[key]
	else:
		return null
	
func get_dict():
	return var_dict

func _restore(a):
	var restore_vars = ["original_mood", "player", "passion1",'passion2',"category1","category2","around_kids", "around_adults", "one_on_one", "wrong_thing", 
	"picked_on", "crowded_places", "attention_kids", "attention_teachers", "they","them","their"]
	for r in restore_vars:
		set_var(r, Rakugo.store.get(r))
	set_var('mood', get_var('original_mood'))
	print(var_dict)
