extends "res://yarn/yarn-importer.gd"

var parent
var audioPlayer

func connect_scene(p, a):
	parent = p
	audioPlayer = a

func yarn_text_variables(text):
	return text

# note: if the <<load x>> command isn't at the end of the yarn node,
# the rest of the node will execute before the load actually happens
func load_new_yarn(scene_name):
	parent.next_scene = str(scene_name)

func end_game():
	parent.end_game()

func story_setting(setting, value):
	pass
	
func show(character, mood, position="center"):
	parent.show(character + " " + mood, {position=position})

func hide(character):
	parent.hide(character)

func say(text):
	var speaker = null
	if ":" in text:
		speaker = text.split(":")[0]
		text = text.split(":")[1]
	parent.say(speaker, text, {'typing': true})
	parent.last_say = [speaker, text]
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
	
func play_audio(audio_name):
	# don't start the audio if it's already playing or if the game's ended
	if parent.current_audio == audio_name:
		return
	parent.current_audio = audio_name
	audioPlayer.stream = parent.audio_dict[audio_name]
	audioPlayer.play()

func stop_audio():
	audioPlayer.stop()
