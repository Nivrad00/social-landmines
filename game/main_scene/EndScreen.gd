extends Control

signal show_main_menu(s)
var shown = 0

func _ready():
	hide()
	for child in $Container.get_children():
		child.modulate.a = 0

func _on_end_game():
	# customize text
	var messages = []
	if Global.get_var('support_hallway'):
		messages.append('Leaving class early to avoid crowded hallways')
	if Global.get_var('support_work'):
		messages.append('Working with teachers to come up with a plan for missed work')
	if Global.get_var('support_lessons'):
		messages.append('Learning missed material after school and during your free period')
	if Global.get_var('support_calming'):
		messages.append('Access to calming activities like a fidget toy or coloring book during class')
	$Container/Supports.text = PoolStringArray(messages).join('\r\n') + '\r\n'
	
	var stressors = []
	if Global.get_var('around_kids') >= 20:
		stressors.append('Being around a lot of kids in school')
	if Global.get_var('around_adults') >= 20:
		stressors.append('Being around a lot of adults in school')
	if Global.get_var('one_on_one') >= 20:
		stressors.append('Having one-on-one conversations with adults in school')
	if Global.get_var('wrong_thing') >= 20:
		stressors.append('Saying the wrong thing to other kids')
	if Global.get_var('picked_on') >= 20:
		stressors.append('Getting picked on or made fun of by other kids')
	if Global.get_var('crowded_places') >= 20:
		stressors.append('Being in crowded places')
	if Global.get_var('attention_kids') >= 20:
		stressors.append('Getting a lot of attention from other kids')
	if Global.get_var('attention_teachers') >= 20:
		stressors.append('Getting a lot of attention from teachers')
	$Container/Stressors.text = PoolStringArray(stressors).join('\r\n') + '\r\n'
	
	# start showing the text
	show()
	add_line()
	yield($Container/Button, 'pressed')
	Rakugo.reset_game()
	Window.Screens._on_nav_button_press('main_menu')

func add_line():
	if shown >= $Container.get_children().size():
		return
	
	else:
		var next_line = $Container.get_child(shown)
		if next_line is Button:
			next_line.disabled = false
		next_line.get_node('AnimationPlayer').play('Fade In')
		shown += 1
		$FadeInTimer.start()
	
