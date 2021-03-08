extends "res://yarn/yarn-importer.gd"

# An example extended class of "yarn-importer"
#
# It is recommended you create your own based on this example.
#
# It is easier to just tie "yarn-importer" directly into your scene,
#  but in time you will likely reuse this class many times, 
#  and it can grow overly complicated merged in your scene
# You might also have multiple types of story GUIs, 
#  then you'd want one of these for each type of GUI

var parent

func connect_scene(p):
	parent = p

func yarn_text_variables(text):
	return text

func story_setting(setting, value):
	pass

func say(text):
	parent.say(null, text)
	parent.last_say = [null, text]
	parent.step()
		
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
