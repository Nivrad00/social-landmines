extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var other = get_node("/root/Main/Node2D/Questions/MarginContainer/PanelContainer/ScrollContainer/VBoxContainer/PersonalQuestions/Pronouns/OtherOption")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("item_selected",self,"on_item_selected")
	add_items()
	

func add_items():
	self.add_item("He/Him/His")
	self.add_item("She/Her/Hers")
	self.add_item("They/Them/Theirs")
	self.add_item("Xe/Xem/Xyrs")
	self.add_item("Other (Please Specify):")

func on_item_selected(id):
	if id == 4:
		other.show()
	else:
		other.hide()


