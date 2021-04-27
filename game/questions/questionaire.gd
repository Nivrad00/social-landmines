extends Control


onready var nameLine = $PageOne/VBoxContainer/PersonalQuestions/Name/askName
onready var pnOptions = $PageOne/VBoxContainer/PersonalQuestions/Pronouns/OptionButton
onready var subNoun = $PageOne/VBoxContainer/PersonalQuestions/Pronouns/OtherOption/subject
onready var objNoun = $PageOne/VBoxContainer/PersonalQuestions/Pronouns/OtherOption/object
onready var posNoun = $PageOne/VBoxContainer/PersonalQuestions/Pronouns/OtherOption/posessive
onready var setMood = $PageThree/MarginContainer2/MoodQuestion/HBoxContainer/TextureRect/TextureProgress
onready var PQ1 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/girlfriend
onready var PQ2 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/boyfriend
onready var PQ3 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/partner
onready var PQ4 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/school
onready var PQ5 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/art
onready var PQ6 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/sports
onready var PQ7 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/theater
onready var PQ8 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/popularity
onready var PQ9 = $PageOne/VBoxContainer/PersonalityQuestions/Checkboxes/friendships

onready var AQ1 = $PageTwo/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/AnxietyQuestions/AQ1/VBoxContainer/HSlider
onready var AQ2 = $PageTwo/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/AnxietyQuestions/AQ2/VBoxContainer/HSlider
onready var AQ3 = $PageTwo/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/AnxietyQuestions/AQ3/VBoxContainer/HSlider
onready var AQ4 = $PageTwo/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/AnxietyQuestions/AQ4/VBoxContainer/HSlider
onready var AQ5 = $PageTwo/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/AnxietyQuestions/AQ5/VBoxContainer/HSlider
onready var AQ6 = $PageTwo/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/AnxietyQuestions/AQ6/VBoxContainer/HSlider
onready var AQ7 = $PageTwo/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/AnxietyQuestions/AQ7/VBoxContainer/HSlider
onready var AQ8 = $PageTwo/MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/AnxietyQuestions/AQ8/VBoxContainer/HSlider

onready var main_dialog = get_node("../MainDialog")

signal submit_success

func _ready():
	pass

func handle_name():
	return nameLine.get_text()

func get_pronouns():
	var option_id = pnOptions.get_selected()
	if(option_id != 4):
		return str(pnOptions.get_item_text(option_id))
	else:
		var otherNouns = subNoun.get_text() + "/" + objNoun.get_text() + "/" + posNoun.get_text()
		return otherNouns

func handle_pronouns(string):
	var nounArray = string.split("/")
	return nounArray

func handle_anxiety():
	var array = [
		AQ1.get_value(),
		AQ2.get_value(),
		AQ3.get_value(),
		AQ4.get_value(),
		AQ5.get_value(),
		AQ6.get_value(),
		AQ7.get_value(),
		AQ8.get_value(),
	]
	return array
	

func handle_mood():
	return setMood.get_value()
	

func basic_errors():
	var errors = 0
	if(nameLine.text.empty()):
		$PageOne/VBoxContainer/PersonalQuestions/Name/HBoxContainer/nameError.show()
		errors = errors + 1
	if(pnOptions.get_selected() == 4 && (subNoun.text.empty() || objNoun.text.empty() || posNoun.text.empty())):
		$PageOne/VBoxContainer/PersonalQuestions/Pronouns/HBoxContainer/pronounError.show()
		errors = errors + 1
	if(handle_checks().size() != 2):
		$PageOne/VBoxContainer/PersonalityQuestions/HBoxContainer/aspectError.show()
		errors = errors + 1
	else:
		return errors
		
func handle_checks():
	var pressed = []
	var checkArray = [
		PQ1,
		PQ2,
		PQ3,
		PQ4,
		PQ5,
		PQ6,
		PQ7,
		PQ8,
		PQ9,
	]
	for i in checkArray:
		if(i.is_pressed()):
			pressed.append(i)
	randomize()
	pressed.shuffle()
	return pressed

func _on_Submit_pressed():
		var personality_array = handle_checks()

		Global.set_var('mood', int(handle_mood()))
		Global.set_var("player", str(handle_name()))
		Global.set_var("passion1", str(personality_array[0].passion))
		Global.set_var("passion2", str(personality_array[1].passion))
		Global.set_var("category1", str(personality_array[0].category))
		Global.set_var("category2", str(personality_array[1].category))
		
		print(str(personality_array[1].category))
		
		var anxieties = ["around_kids", "around_adults", "one_on_one", "wrong_thing", 
		"picked_on", "crowded_places", "attention_kids", "attention_teachers"]
		for i in range(0,len(anxieties)):
			var response = handle_anxiety()[i]
			if response <= 2:
				Global.set_var(anxieties[i], 10)
			elif response <= 5:
				Global.set_var(anxieties[i], 20)
			elif response <= 8:
				Global.set_var(anxieties[i], 30)

		Global.set_var("they", handle_pronouns(get_pronouns())[0].to_lower())
		Global.set_var("them", handle_pronouns(get_pronouns())[1].to_lower())
		Global.set_var("their", handle_pronouns(get_pronouns())[2].to_lower())
		
		emit_signal("submit_success")
		
		# old code
		
		#main_dialog.set_var("$player", str(handle_name()))
		#main_dialog.set_var("$passion1", str(personality_array[0].passion))
		#main_dialog.set_var("$passion2", str(personality_array[1].passion))
		#main_dialog.set_var("$category1", str(personality_array[0].category))
		#main_dialog.set_var("$category2", str(personality_array[1].category))
		
		#var anxieties = ["$around_kids", "$around_adults", "$one_on_one", "$wrong_thing", 
		#"$picked_on", "$crowded_places", "$attention_kids", "$attention_teachers"]
		#for i in range(0,len(anxieties)):
			#main_dialog.set_var(anxieties[i], handle_anxiety()[i])

		#main_dialog.set_var("$they", handle_pronouns(get_pronouns())[0].to_lower())
		#main_dialog.set_var("$them", handle_pronouns(get_pronouns())[1].to_lower())
		#main_dialog.set_var("$their", handle_pronouns(get_pronouns())[2].to_lower())
		
		#print(main_dialog.yarn_importer.environment)


func _on_PageOneNext_pressed():
	if(basic_errors() != 0):
		pass
	else:
		$PageOne.hide()
		$PageTwo.show()


func _on_PageTwoBack_pressed():
	$PageTwo.hide()
	$PageOne.show()


func _on_PageTwoNext_pressed():
	$PageTwo.hide()
	$PageThree.show()


func _on_PageThreeBack_pressed():
	$PageThree.hide()
	$PageTwo.show()
