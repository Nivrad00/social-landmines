extends Dialogue

var yarn_importer = null
var yarn_path = 'res://yarn/script.yarn.txt'
var current_choices = []
var initialized = false
var next_marker = null

func _ready():
	yarn_importer = load('res://yarn/yarn-rakugo-interface.gd').new()
	yarn_importer.connect_scene(self)
	
	Rakugo.define_character("Background", "background", Color.pink)
	
func default_event():
	start_event("default_event")
	
	# for some reason putting an extra choice at the beginning makes cond() start working
	say(null, 'test choice')
	var chooice = menu([['first', 'O', {}], ['second', 'EEEE', {}]])
	if cond(chooice == 'O'):
		if is_active():
			print('you choose O')
	elif cond(chooice == 'EEEE'):
		if is_active():
			print('EEEEEEEEEEEe')
	step()
	
	# loop through the yarn story
	while true:
		current_choices = []
		
		# if this is the first thread, start from the beginning
		if not initialized:
			yarn_importer.spin_yarn(yarn_path)
			initialized = true
		
		# else...
		else:
			# if the player made a choice, go to the corresponding marker
			if next_marker:
				yarn_importer.yarn_unravel(next_marker)
			# else... nothing, because currently there's only choices
			else:
				yarn_importer.yarn_unravel('dummy')
		
		next_marker = null
		
		# if any choices were populated while unraveling, then display the choice
		if current_choices.size() > 0:
			var choice = menu(current_choices)
					
			# check what the player chose, which determines the next thread
			for data in current_choices:
				if cond(choice == data[1]):
					if is_active():
						next_marker = data[1]
		step()
		
	end_event()
