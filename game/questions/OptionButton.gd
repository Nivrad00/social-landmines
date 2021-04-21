extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var other = get_node("/root/Main/Questions/PageOne/VBoxContainer/PersonalQuestions/Pronouns/OtherOption")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("item_selected",self,"on_item_selected")
	add_items()
	

func add_items():
	self.add_item("He/Him/His")
	self.add_item("She/Her/Her")
	self.add_item("They/Them/Their")
	self.add_item("Xe/Xem/Xyr")
	self.add_item("Other (Please Specify):")

func on_item_selected(id):
	if id == 4:
		other.show()
	else:
		other.hide()


