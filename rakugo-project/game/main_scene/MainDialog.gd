extends Dialogue

var yarn_importer = null
var yarn_path = 'res://yarn/script.yarn.txt'
var current_choices = []
var next_marker = null
var last_say = [null, '']

func _ready():
	yarn_importer = load('res://yarn/yarn-rakugo-interface.gd').new()
	yarn_importer.connect_scene(self)
	
	Rakugo.define_character("Background", "background", Color.pink)
	
func default_event():
	# print('entering default event')
	start_event("default_event")
	
	# start by initializing the yarn story and proceeding up to the first choice
	current_choices = []
	# print('initializing yarn story')
	yarn_importer.spin_yarn(yarn_path)
	
	# then continue looping through the story, handling choices as they appear
	while true:
		# the loop should end if the thread isn't running (that is, this thread is obsolete)
		if not is_running():
			# print('breaking out from dialog loop')
			break
			
		next_marker = null
			
		# if any choices were populated while unraveling, then display the choice
		# also repeat the previous say(), since rakugo expects a say() to accompany every choice
		if current_choices.size() > 0:
			say(last_say[0], last_say[1])
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
			yarn_importer.yarn_unravel(next_marker)
		
	end_event()
