extends "res://yarn/yarn-importer.gd"

var parent

# note: if the <<load x>> command isn't at the end of the yarn node,
# the rest of the node will execute before the load actually happens
func load_new_yarn(scene_name):
	parent.next_scene = str(scene_name)
	
func connect_scene(p):
	parent = p

func yarn_text_variables(text):
	return text

func story_setting(setting, value):
	pass

func say(text):
	parent.say(null, text, {'typing': true})
	parent.last_say = [null, text]
	parent.step()
		
# like load, if the choices aren't at the end of the node,
# the rest of the node will execute before the choice actually appears
func choice(text, marker):
	parent.current_choices.append([text, marker, {}])
	
func action(text):
	pass
	
func display_image(name):
	parent.show(name)
	
func yarn_custom_logic(to):
	pass

func yarn_custom_logic_after(to):
	pass
