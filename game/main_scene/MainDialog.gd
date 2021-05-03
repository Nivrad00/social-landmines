extends Dialogue

var yarn_importer = null
var yarn_path = 'res://yarn/'
var default_yarn_scene = '1 reentry meeting'
onready var quest = get_node("../Questions")
onready var choice = get_node("/root/Window/Panel/TabContainer/InGameGUI/ChoiceMenu")
onready var dialogue = get_node("/root/Window/Panel/TabContainer/InGameGUI/DialoguePanel")
onready var resource = get_node("/root/Window/Panel/TabContainer/InGameGUI/ResourcesMenu")
onready var therm = get_node("/root/Window/Panel/TabContainer/InGameGUI/MoodThermometer")
onready var quick = get_node("/root/Window/Panel/TabContainer/InGameGUI/QuickMenu")

var current_choices = []
var next_scene = null
var next_marker = null
var first_time = true
var last_say = [null, '']
var current_audio = null
var audio_dict = {}

signal end_game

onready var audioPlayer = get_node("../YarnAudioPlayer")

func _ready():	
	Rakugo.define_character("Background", "Background", Color.pink)
	Rakugo.define_character("Teacher", "Teacher", Color.red)
	Rakugo.define_character("Brad", "Brad", Color.red)
	Rakugo.define_character("Chad", "Chad", Color.yellow)
	Rakugo.define_character("Juana", "Juana", Color.green)
	Rakugo.define_character("Peer2", "Peer2", Color.green)
	yarn_importer = load('res://yarn/yarn-rakugo-interface.gd').new()
	yarn_importer.connect_scene(self, audioPlayer)
	
	# preload audio, otherwise there are issues
	# check for .wav.import -- the .wav's themselves aren't detected in the exported build
	var dir = Directory.new()
	var path = 'res://game/audio/'
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				var split = file_name.split('.')
				if split[-1] == 'import' and split[-2] == 'wav':
					var new_file_name = file_name.substr(0, file_name.length()-7)
					audio_dict[new_file_name] = load(path + new_file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to load the audio files.")
		

func default_event():
	if first_time:
		first_time = false
	
	print('entering default event')
	start_event("default_event")
	
	# no audio during questionnaire please
	yarn_importer.stop_audio()
	
	# reset end screen at the start of each game
	$'../EndScreen'.reset()
	
	# start with quesionnaire stuff
	quest.show()
	choice.hide()
	dialogue.hide()
	resource.hide()
	therm.hide()
	quick.hide()
	
	step()
	
	quest.hide()
	choice.show()
	dialogue.show()
	resource.show()
	therm.show()
	quick.show()
	
	# then initialize the yarn story and proceed up to the first choice
	current_choices = []
	next_scene = null
	# print('initializing yarn story')
	
	yarn_importer.spin_yarn(yarn_path + default_yarn_scene + '.yarn')
	
	# then continue looping through the story, handling choices as they appear
	while true:
		# the loop should end if the thread isn't running (that is, this thread is obsolete)
		if not is_running():
			break
			
		next_marker = null
			
		# if any choices were populated while unraveling, then display the choice
		# also repeat the previous say(), since rakugo expects a say() to accompany every choice
		# make sure it doesn't log the repeated line in the history, though
		if current_choices.size() > 0:
			say(last_say[0], last_say[1], {'no_history': true, 'typing': false})
			last_say = [null, '']
			var choice = menu(current_choices)
			step()
					
			# check what the player chose, which determines the next thread
			for data in current_choices:
				if cond(choice == data[1]):
					next_marker = data[1]
			
			# then go to the marker corresponding to the player's choice
			if next_marker:
				current_choices = []
				next_scene = null
				yarn_importer.yarn_unravel(next_marker)
				
		# else if next_scene was set, then we're jumping to another yarn file
		elif next_scene:
			var path = yarn_path + next_scene + '.yarn'
			current_choices = []
			next_scene = null
			yarn_importer.spin_yarn(path)
			
		# else we're lost -- exit the loop
		else:
			break
		
	end_event()

func end_game():
	if is_running():
		dialogue.hide() # hide any text that might be lingering
		emit_signal('end_game')
		
		# after they read the end screen and press "back"...
		yield($'../EndScreen/Container/Button', 'pressed')
		Rakugo.reset_game()
		Window.Screens._on_nav_button_press('main_menu')
	
#set a var in the yarn environment
func set_var(variable, value):
	yarn_importer.environment[variable] = value
