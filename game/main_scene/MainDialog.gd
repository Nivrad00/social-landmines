extends Dialogue

var yarn_importer = null
var yarn_path = 'res://yarn/'
var default_yarn_scene = '1 reentry meeting'

var current_choices = []
var next_scene = null
var next_marker = null
var last_say = [null, '']

signal end_game

onready var question = get_node("../Node2D/Questions")
onready var audioPlayer = get_node("../YarnAudioPlayer")

func _ready():	
	Rakugo.define_character("Background", "Background", Color.pink)
	Rakugo.define_character("Teacher", "Teacher", Color.red)
	Rakugo.define_character("Brad", "Brad", Color.red)
	Rakugo.define_character("Chad", "Chad", Color.yellow)
	Rakugo.define_character("Peer", "Peer", Color.green)

func default_event():
	# print('entering default event')
	question.show()
	start_event("default_event")
	# placeholder for questionnaire
	Global.trigger = 'Social'
	
	# start by initializing the yarn story and proceeding up to the first choice
	current_choices = []
	next_scene = null
	# print('initializing yarn story')
	yarn_importer = load('res://yarn/yarn-rakugo-interface.gd').new()
	yarn_importer.connect_scene(self, audioPlayer)
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
	emit_signal('end_game')
