extends Dialogue

var question_shown = false
onready var quest = get_node("../Questions")
onready var choice = get_node("/root/Window/Panel/TabContainer/InGameGUI/ChoiceMenu")
onready var dialogue = get_node("/root/Window/Panel/TabContainer/InGameGUI/DialoguePanel")
onready var resource = get_node("/root/Window/Panel/TabContainer/InGameGUI/ResourcesMenu")
onready var therm = get_node("/root/Window/Panel/TabContainer/InGameGUI/MoodThermometer")
onready var quick = get_node("/root/Window/Panel/TabContainer/InGameGUI/QuickMenu")


func _ready():
	question_shown = true
	choice.hide()
	dialogue.hide()
	resource.hide()
	therm.hide()
	quick.hide()
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
