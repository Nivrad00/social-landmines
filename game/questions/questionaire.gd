extends Control

onready var nameLine = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalQuestions/Name/LineEdit")
onready var pnOptions = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalQuestions/Pronouns/OptionButton")
onready var subNoun = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalQuestions/Pronouns/OtherOption/subject")
onready var objNoun = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalQuestions/Pronouns/OtherOption/object")
onready var posNoun = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalQuestions/Pronouns/OtherOption/posessive")
onready var setMood = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/MoodQuestion/CenterContainer/TextureRect/TextureProgress")
onready var AQ1 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/AnxietyQuestions/Question1/VBoxContainer/HSlider")
onready var AQ2 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/AnxietyQuestions/Question2/VBoxContainer/HSlider")
onready var AQ3 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/AnxietyQuestions/Question3/VBoxContainer/HSlider")
onready var AQ4 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/AnxietyQuestions/Question4/VBoxContainer/HSlider")
onready var AQ5 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/AnxietyQuestions/Question5/VBoxContainer/HSlider")
onready var AQ6 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/AnxietyQuestions/Question6/VBoxContainer/HSlider")
onready var AQ7 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/AnxietyQuestions/Question7/VBoxContainer/HSlider")
onready var AQ8 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/AnxietyQuestions/Question8/VBoxContainer/HSlider")
onready var check1 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox")
onready var check2 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox2")
onready var check3 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox3")
onready var check4 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox4")
onready var check5 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox5")
onready var check6 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox6")
onready var check7 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox7")
onready var check8 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox8")
onready var check9 = get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalityQuestions/Checkboxes/CheckBox9")
onready var main_dialog = get_node("../MainDialog")

signal submit_success

func _ready():
	pass

func handle_name():
	return nameLine.get_text()

func handle_pronouns():
	var option_id = pnOptions.get_selected()
	if(option_id != 4):
		return str(pnOptions.get_item_text(option_id))
	else:
		var otherNouns = subNoun.get_text() + "/" + objNoun.get_text() + "/" + posNoun.get_text()
		return otherNouns

func handle_anxiety():
	var array = [
		AQ1.get_value(),
		AQ2.get_value(),
		AQ3.get_value(),
		AQ4.get_value(),
		AQ5.get_value(),
		AQ6.get_value(),
		AQ7.get_value(),
		AQ8.get_value()
	]
	return array
	

func handle_mood():
	return setMood.get_value()
	


func basic_errors():
	if(nameLine.text.empty()):
		return true
	elif(pnOptions.get_selected() == 4 && (subNoun.text.empty() || objNoun.text.empty() || posNoun.text.empty())):
		return true
	else:
		return false
		
func handle_checks():
	var pressed = []
	var checkArray = [
		check1,
		check2,
		check3,
		check4,
		check5,
		check6,
		check7,
		check8,
		check9,
	]
	for i in checkArray:
		if(i.is_pressed()):
			pressed.append(i.get_text())
	return pressed

func _on_Button_pressed():
	#if(basic_errors()):
	#	print(nameLine.text.empty())
	#	print(pnOptions.get_selected() == 4 && (subNoun.text.empty() || objNoun.text.empty() || posNoun.text.empty()))
	#	print("errors exist")
	#else:
		Global.mood = int(handle_mood())
		Global.playerName = str(handle_name())
		#set variables in yarn from questionnaire
		main_dialog.set_var("$player", str(handle_name()))
		main_dialog.set_var("$passion1", str(handle_checks()[0]))
		main_dialog.set_var("$passion2", str(handle_checks()[1]))
		var anxieties = ["$around_kids", "$around_adults", "$one_on_one", "$wrong_thing", 
		"$picked_on", "$crowded_places", "$attention_kids", "$attention_teachers"]
		for i in range(0,len(anxieties)):
			main_dialog.set_var(anxieties[i], handle_anxiety()[i])
		main_dialog.set_var("$pronoun_sbj", handle_pronouns().split("/")[0].to_lower())
		main_dialog.set_var("$pronoun_obj", handle_pronouns().split("/")[1].to_lower())
		main_dialog.set_var("$pronoun_pos", handle_pronouns().split("/")[2].to_lower())
		emit_signal("submit_success")
		


func _on_HSlider_value_changed(value):
	pass # Replace with function body.
