extends VBoxContainer


onready var otherBox = $OtherOption
onready var dd = $OptionButton
func _ready():
	dd.connect("item_selected",self,"on_item_selected")
	add_items()
	

func add_items():
	dd.add_item("He/Him/His")
	dd.add_item("She/Her/Her")
	dd.add_item("They/Them/Their")
	dd.add_item("Xe/Xem/Xyr")
	dd.add_item("Other (Please Specify):")

func on_item_selected(id):
	if id == 4:
		otherBox.show()
	else:
		otherBox.hide()


