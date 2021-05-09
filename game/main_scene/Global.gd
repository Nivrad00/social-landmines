extends Node

signal mood_changed

# contains all global variables
var var_dict = {}

func set_var(key, value):
	var_dict[key] = value
	Rakugo.store.set(key,value)
	Rakugo.store.set("var_list", var_dict.keys())
	if key == 'mood':
		if not var_dict.has('original_mood'):
			set_var('original_mood',value)
		emit_signal("mood_changed", value)

# keep track of minigame changes to thermometer
func set_mood_minigame(value):
	var current_mood = get_var("mood")
	var delta = (100 - current_mood) if value > 100 else (0 - current_mood) if value < 0 else (value - current_mood)
	set_var("mood", current_mood + delta)
	var d = get_var("minigame_mood_diff")
	if d:
		set_var("minigame_mood_diff", d + delta)
	else:
		set_var("minigame_mood_diff", delta)
		
func get_var(key):
	if key in var_dict:
		return var_dict[key]
	else:
		return null
	
func get_dict():
	return var_dict

# called when game ends
func reset():
	var_dict = {}
	
func _restore(a):
	# if loading save from a fresh game
	var original_mood = null
	if not var_dict.has("original_mood"):
		original_mood = Rakugo.store.get("original_mood")
	
	# restore from rakugo save to here
	var restore_vars = Rakugo.store.get("var_list")
	for r in restore_vars:
		set_var(r, Rakugo.store.get(r))
	
	# if loading from fresh state
	if original_mood: 
		set_var('original_mood', original_mood)
	# add minigame changes if var has been set
	var diff = get_var('minigame_mood_diff') if get_var('minigame_mood_diff') else 0
	set_var('mood', get_var('original_mood') + diff)
