extends Node
#
# A YARN Importer for Godot
#
# Credits: 
# - Dave Kerr (http://www.naturallyintelligent.com)
# 
# Latest: https://github.com/naturally-intelligent/godot-yarn-importer
# 
# Yarn: https://github.com/InfiniteAmmoInc/Yarn
# Twine: http://twinery.org
# 
# Yarn: a ball of threads (Yarn file)
# Thread: a series of fibres (Yarn node)
# Fibre: a text or choice or logic (Yarn line)

var yarn = {}
var environment = {}
var skip = false
var if_hit = false
var bracketRegex = RegEx.new()

func clean_environment(env):
	environment = {}
	

# OVERRIDE METHODS
#
# called to request new dialog
func say(text):
	pass
	
func play_audio(audio_name):
	pass
	
func stop_audio():
	pass
	
# called to request new choice button
func choice(text, marker):
	pass

# called to move to a different yarn file
func load_new_yarn(scene_name):
	pass
	
# called when the game ends (duh)
func end_game():
	pass
	
func show(character, mood, position=null):
	pass

func hide(character):
	pass

# evaluate logic / math expressions
func evaluate(expr):
	var evalTokenizer = EvalTokenizer.new()
	var evalTree = EvalTree.new(evalTokenizer.tokenize(expr))
	var evalEvaluator = EvalEvaluate.new(evalTree.get_tree())
	
	# use both local and global variables
	var all_vars = {}
	var global_vars = Global.get_dict()
	for var_name in global_vars:
		all_vars['$' + var_name] = global_vars[var_name]
	for var_name in environment:
		all_vars[var_name] = environment[var_name]
	return evalEvaluator.evaluate(all_vars)

#process inline expressions in text
func say_preprocess(text):
	var m = bracketRegex.search(text)
	if not m:
		return text
	else:
		var evaluated = evaluate(m.get_string())
		text = text.substr(0,m.get_start()) + str(evaluated) + text.substr(m.get_end(), len(text))
		return say_preprocess(text)

# handle non-logic commands (music, images, scene changes)
func command(cmd):
	var split = cmd.split(" ")
	match split[0]:
		'show':
			if len(split) == 4:
				show(split[1],split[2],split[3])
			else:
				show(split[1],split[2])
		'play':
			play_audio(cmd.split("play ")[1])
		'hide':
			hide(split[1])
		'stop':
			stop_audio()
		'load':
			split.remove(0)
			load_new_yarn(split.join(" "))
		'end':
			end_game()

# handles conditional handling and variable definition
func logic(statement):
	statement = statement.strip_edges()
	var split_statement = statement.split(" ")
	
	# "SET variable TO expression"
	if split_statement[0] == "set" and not skip:
		if split_statement[1].substr(0, 1) == '$':
			
			# set variables in Global (without the $)
			var var_name = split_statement[1].substr(1)
			var value = evaluate(statement.split("to")[1])
			
			# prevent mood from being set outside of 0-100
			if var_name == "mood":
				if value > 100:
					Global.set_var("mood", 100)
				elif value < 0:
					Global.set_var("mood", 0)
				else:
					Global.set_var("mood", value)
			else:
				Global.set_var(var_name, value)
			
			# local "environment" variables not currently used
			# var var_name = split_statement[1]
			# environment[var_name] = evaluate(statement.split("to")[1])
		
	# "IF expression"
	elif split_statement[0] == "if":
		if not evaluate(statement.split("if")[1]):
			skip = true
		else:
			if_hit = true
			
	# "ELSEIF expression"
	elif split_statement[0] == "elseif":
		var check = evaluate(statement.split("elseif")[1])
		if not check or if_hit:
			skip = true
		else:
			skip = false
			if_hit = true
			
	#run statements under else if no if/elseif ran
	elif split_statement[0] == "else":
		skip = if_hit
		
	#end of conditionals, reset vars
	elif split_statement[0] == "endif":
		skip = false
		if_hit = false

	# other commands handled by command func
	else:
		if not skip:
			command(statement)

	
# called for each line of text
func yarn_text_variables(text):
	return text
	
# called when "settings" node parsed
func story_setting(setting, value):
	pass
	
# called for each node name
func yarn_custom_logic(to):
	pass
	
func display_image(path):
	pass

# called for each node name (after)
func yarn_custom_logic_after(to):
	pass

# START SPINNING YOUR YARN
#
func spin_yarn(file, start_thread = false):
	# start by resetting some of the state
	skip = false
	if_hit = false
	# fix for loading from save variable issues
	clean_environment(environment)
	# okay now go ahead
	
	yarn = load_yarn(file)
	bracketRegex.compile("{[^{}]*}")
	# Find the starting thread...
	if not start_thread:
		start_thread = yarn['start']
	# Load any scene-specific settings
	# (Not part of official Yarn standard)
	if 'settings' in yarn['threads']:
		var settings = yarn['threads']['settings']
		for fibre in settings['fibres']:
			var line = fibre['text']
			var split = line.split('=')
			var setting = split[0].strip_edges(true, true)
			var value = split[1].strip_edges(true, true)
			story_setting(setting, value)
	# First thread unravel...
	yarn_unravel(start_thread)

# Internally create a new thread (during loading)
func new_yarn_thread():
	var thread = {}
	thread['title'] = ''
	thread['kind'] = 'branch' # 'branch' for standard dialog, 'code' for gdscript
	thread['tags'] = [] # unused
	thread['fibres'] = []
	return thread

# Internally create a new fibre (during loading)
func new_yarn_fibre(line):
	# choice fibre
	line = line.strip_edges()
	if line.substr(0,2) == '[[':
		if line.find('|') != -1:
			var fibre = {}
			fibre['kind'] = 'choice'
			line = line.replace('[[', '')
			line = line.replace(']]', '')
			var split = line.split('|')
			fibre['text'] = split[0]
			fibre['marker'] = split[1]
			return fibre
		else:
			var fibre = {}
			fibre['kind'] = 'jump'
			line = line.replace('[[', '')
			line = line.replace(']]', '')
			var split = line.split('|')
			fibre['marker'] = split[0]
			return fibre
			
	# logic instructions
	elif line.strip_edges().substr(0,2) == '<<':
		var fibre = {}
		fibre['kind'] = 'logic'
		line = line.replace('<<', '')
		line = line.replace('>>', '')
		fibre['statement'] = line
		return fibre
	elif line.strip_edges().substr(0,5) == '[img]':
		var fibre = {}
		fibre['kind'] = 'image'
		line = line.replace('[img]', '')
		line = line.replace('[/img]', '')
		fibre['path'] = line
		return fibre
	
	# text fibre
	elif line.strip_edges().length() > 0:
		var fibre = {}
		fibre['kind'] = 'text'
		fibre['text'] = line.strip_edges()
		return fibre
	
	# ignore empty lines
	return null
	

# Create Yarn data structure from file (must be *.yarn.txt Yarn format)
func load_yarn(path):
	var yarn = {}
	yarn['threads'] = {}
	yarn['start'] = false
	yarn['file'] = path
	var file = File.new()
	file.open(path, file.READ)
	if file.is_open():
		# yarn reading flags
		var start = false
		var header = true
		var thread = new_yarn_thread()
		# loop
		while !file.eof_reached():
			# read a line
			var line = file.get_line()
			# header read mode
			if header:
				if line == '---':
					header = false
				else:
					var split = line.split(': ')
					if split[0] == 'title':
						var title_split = split[1].split(':')
						var thread_title = ''
						var thread_kind = 'branch'
						if len(title_split) == 1:
							thread_title = split[1]
						else:
							thread_title = title_split[1]
							thread_kind = title_split[0]
						thread['title'] = thread_title
						thread['kind'] = thread_kind
						if not yarn['start']:
							yarn['start'] = thread_title
			# end of thread
			elif line == '===':
				header = true
				yarn['threads'][thread['title']] = thread
				thread = new_yarn_thread()
			# fibre read mode
			else:
				var fibre = new_yarn_fibre(line)
				if fibre:
					thread['fibres'].append(fibre)
	else:
		print('ERROR: Yarn file missing: ', filename)
	return yarn

# Main logic for node handling
#
func yarn_unravel(to, from=false):
	yarn_custom_logic(to)
	skip = false
	if_hit = false
	if to in yarn['threads']:
		var thread = yarn['threads'][to]
		match thread['kind']:
			'branch':
				for fibre in thread['fibres']:
					match fibre['kind']:
						'text':
							var text = yarn_text_variables(fibre['text'])
							if not skip:
								say(say_preprocess(text))
						'choice':
							var text = yarn_text_variables(fibre['text'])
							if not skip:
								choice(text, fibre['marker'])
						'jump':
							if not skip:
								yarn_unravel(fibre['marker'])
						'logic':
							var statement = fibre['statement']
							logic(statement)
						'image':
							if not skip:
								display_image(fibre['path'])
			'code':
				yarn_code(to)
	else:
		print('WARNING: Missing Yarn thread: ', to, ' in file ',yarn['file'])
	yarn_custom_logic_after(to)

#
# RUN GDSCRIPT CODE FROM YARN NODE - Special node = code:title
# - Not part of official Yarn standard
#
func yarn_code(title, run=true, parent='parent.', tabs="\t", next_func="yarn_unravel"):
	if title in yarn['threads']:
		var thread = yarn['threads'][title]
		var code = ''
		for fibre in thread['fibres']:
			match fibre['kind']:
				'text':
					var line = yarn_text_variables(fibre['text'])
					line = yarn_code_replace(line, parent, next_func)
					code += tabs + line + "\n"
				'choice':
					var line = parent+next_func+"('"+fibre['marker']+"')"
					code += tabs + line + "\n"
		if run:
			run_yarn_code(code)
		else:
			return code
	else:
		print('WARNING: Title missing in yarn ball: ', title)

# override to replace convenience variables
func yarn_code_replace(code, parent='parent.', next_func="yarn_unravel"):
	if code.find("[[") != -1:
		code = code.replace("[[", parent+next_func+"('")
		code = code.replace("]]", "')")
	code = code.replace("say(", parent+"say(")
	code = code.replace("choice(", parent+"choice(")
	return code

func run_yarn_code(code):
	var front = "extends Node\n"
	front += "func dynamic_code():\n"
	front += "\tvar parent = get_parent()\n\n"
	code = front + code
	#print("CODE BLOCK: \n", code)

	var script = GDScript.new()
	script.set_source_code(code)
	script.reload()

	#print("Executing code...")
	var node = Node.new()
	node.set_script(script)
	add_child(node)
	var result = node.dynamic_code()
	remove_child(node)

	return result

# EXPORTING TO GDSCRIPT
#
# This code may not be directly usable
# Use if you need an exit from Yarn

func export_to_gdscript():
	var script = ''
	script += "func start_story():\n\n"
	if 'settings' in yarn['threads']:
		var settings = yarn['threads']['settings']
		for fibre in settings['fibres']:
			var line = fibre['text']
			var split = line.split('=')
			var setting = split[0].strip_edges(true, true)
			var value = split[1].strip_edges(true, true)
			script += "\t" + 'story_setting("' + setting + '", "' + value + '")' + "\n"
	script += "\tstory_logic('" + yarn['start'] + "')\n\n"
	# story logic choice/press event
	script += "func story_logic(marker):\n\n"
	script += "\tmatch marker:\n"
	for title in yarn['threads']:
		var thread = yarn['threads'][title]
		match thread['kind']:
			'branch':
				var code = "\n\t\t'" + thread['title'] + "':"
				var tabs = "\n\t\t\t"
				for fibre in thread['fibres']:
					match fibre['kind']:
						'text':
							code += tabs + 'say("' + fibre['text'] + '")'
						'choice':
							code += tabs + 'choice("' + fibre['text'] + '", "' + fibre['marker'] + '")'
						'logic':
							code += tabs + 'logic("' + fibre['instruction'] + '", "' + fibre['command'] + '")'
				script += code + "\n"
			'code':
				var code = "\n\t\t'" + thread['title'] + "':"
				var tabs = "\n\t\t\t"
				code += "\n"
				code += yarn_code(thread['title'], false, '', "\t\t\t", "story_logic")
				script += code + "\n"
	# done
	return script

func print_gdscript_to_console():
	print(export_to_gdscript())

func save_to_gdscript(filename):
	var script = export_to_gdscript()
	# write to file
	var file = File.new()
	file.open(filename, file.WRITE)
	if not file.is_open():
		print('ERROR: Cant open file ', filename)
		return false
	file.store_string(script)
	file.close()
