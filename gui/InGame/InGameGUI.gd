extends Control

var hide_toggle = false
# i know hardcoded paths are bad, but it seems silly to establish
# a new signal system just for one button...
onready var skip_button = $QuickMenu/ButtonList/Skip
onready var quest = get_node("/root/Main/questions")
func _ready():
	Rakugo.connect("game_ended", self, "_on_game_end")
	$SkipDisplay.hide()
	
func _input(event):
	if visible:
		# not sure what this is for
		if event.is_action_pressed("ui_cancel"):
			Window.Screens.call_deferred('_on_nav_button_press', "save")
		
		# this option was unbound - we don't need two different ways to skip
		if event.is_action_pressed("rakugo_skip"):
			Rakugo.activate_skipping()
		if event.is_action_released("rakugo_skip"):
			Rakugo.deactivate_skipping()
		
		# however, the toggled skip works and is bound to tab
		if event.is_action_pressed("rakugo_skip_toggle"):
			# ignore while resources menu or minigame is open
			if not $ResourcesMenu.dropdown_shown and not $Minigames.minigame_shown:
				if Rakugo.skipping:
					Rakugo.deactivate_skipping()
					$SkipDisplay.hide()
					skip_button.pressed = false
				else:
					Rakugo.activate_skipping()
					$SkipDisplay.show()
					skip_button.pressed = true
			
		if event.is_action_pressed("rakugo_rollback"):
			# ignore while resources menu or minigame is open
			if not $ResourcesMenu.dropdown_shown and not $Minigames.minigame_shown and not quest.question_shown :
				Rakugo.rollback(1)
				
		if event.is_action_pressed("rakugo_rollforward"):
			# ignore while resources menu or minigame is open
			if not $ResourcesMenu.dropdown_shown and not $Minigames.minigame_shown and not quest.question_shown:
				Rakugo.rollback(-1)
			
		# the hide ui options were unbound
		if event.is_action_pressed("rakugo_hide_ui"):
			hide()
		if event.is_action_pressed("rakugo_hide_ui_toggle"):
			hide_toggle = true
			hide()
			
	elif Window.get_current_ui() == self:
		if event.is_action_released("rakugo_hide_ui"):
			hide_toggle = false
			show()
		if hide_toggle and event.is_action_pressed("rakugo_hide_ui_toggle"):
			hide_toggle = false
			show()


func _unhandled_input(event):
	if event.is_action_pressed("ui_left_click"):
		Rakugo.story_step()


func _on_quick_button_press(quick_action):
	match quick_action:
		"hide":
			hide_toggle = true
			hide()
			
		"skip":
			# ignore while resources menu or minigame is open
			# (it shouldn't be possible to hit quick menu buttons while
			#    one of those is open -- but just in case)
			if not $ResourcesMenu.dropdown_shown and not $Minigames.minigame_shown:
				if Rakugo.skipping:
					Rakugo.deactivate_skipping()
					$SkipDisplay.hide()
				else:
					Rakugo.activate_skipping()
					$SkipDisplay.show()
					
		"back":
			# ignore while resources menu or minigame is open
			if not $ResourcesMenu.dropdown_shown and not $Minigames.minigame_shown:
				Rakugo.rollback(1)
			
		_:
			Window.Screens._on_nav_button_press(quick_action)

func _on_resource_button_press(resource_name):
	# when the user wants to use a resource!
	# currently minigame state isn't stored, so saving during a minigame and then loading
	#   that save should just cause the minigame to disappear
	
	if resource_name == 'Counselor':
		return # todo
		
	$Minigames.show()
	$Minigames.start_minigame(resource_name)

func _on_resources_menu_opened():
	# stop skipping when the resources menu opens
	if Rakugo.skipping:
		Rakugo.deactivate_skipping()
		$SkipDisplay.hide()
		skip_button.pressed = false
	
func _on_minigame_started():
	# stop skipping when a minigame starts
	# (this is in case there's a point in the game where a minigame can be accessed
	#    without going through the resources menu)
	if Rakugo.skipping:
		Rakugo.deactivate_skipping()
		$SkipDisplay.hide()
		skip_button.pressed = false
	
# this is called not just when the game ends, but also when a file is loaded
func _on_game_end():
	Rakugo.deactivate_skipping()
	$SkipDisplay.hide()
	skip_button.pressed = false
	$ResourcesMenu.hide_dropdown_immediately()
	$Minigames.end_minigame_immediately()
	
