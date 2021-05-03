# this script is outdated! questionnaire stuff is now handled entirely by MainDialog
extends Dialogue

#controls rollback
var question_shown = false

#connect to UI elements
onready var quest = get_node("../Questions")
onready var choice = get_node("/root/Window/Panel/TabContainer/InGameGUI/ChoiceMenu")
onready var dialogue = get_node("/root/Window/Panel/TabContainer/InGameGUI/DialoguePanel")
onready var resource = get_node("/root/Window/Panel/TabContainer/InGameGUI/ResourcesMenu")
onready var therm = get_node("/root/Window/Panel/TabContainer/InGameGUI/MoodThermometer")
onready var quick = get_node("/root/Window/Panel/TabContainer/InGameGUI/QuickMenu")


func _ready():
	#when this is true, rollback is disabled
	question_shown = true
	
	#hide UI elements
	choice.hide()
	dialogue.hide()
	resource.hide()
	therm.hide()
	quick.hide()
	
	#connect to submit button signal
	quest.connect("submit_success", self, "submit")


func questions():
	start_event("questions")
	
	quest.show()
	
	step()
	

	question_shown = false
	jump("","MainDialog","")
	
	end_event()

func submit():
	Rakugo.story_step()

	return
