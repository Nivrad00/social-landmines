extends VBoxContainer

onready var check1 = get_node("Checkboxes/CheckBox")
onready var check2 = get_node("Checkboxes/CheckBox2")
onready var check3 = get_node("Checkboxes/CheckBox3")
onready var check4 = get_node("Checkboxes/CheckBox4")
onready var check5 = get_node("Checkboxes/CheckBox5")
onready var check6 = get_node("Checkboxes/CheckBox6")
onready var check7 = get_node("Checkboxes/CheckBox7")
onready var check8 = get_node("Checkboxes/CheckBox8")
onready var check9 = get_node("Checkboxes/CheckBox9")
var checked = []

func _ready():
	check1.connect("toggled",self,"limit_checks",[check1])
	check2.connect("toggled",self,"limit_checks",[check2])
	check3.connect("toggled",self,"limit_checks",[check3])
	check4.connect("toggled",self,"limit_checks",[check4])
	check5.connect("toggled",self,"limit_checks",[check5])
	check6.connect("toggled",self,"limit_checks",[check6])
	check7.connect("toggled",self,"limit_checks",[check7])
	check8.connect("toggled",self,"limit_checks",[check8])
	check9.connect("toggled",self,"limit_checks",[check9])


func limit_checks(button_pressed,which):
	if(checked.size()<2 && button_pressed == true):
		checked.append(which)
	elif(checked.size() == 2 && button_pressed == true):
		checked[0].set_pressed(false)
		checked.append(which)
	elif(button_pressed == false):
		checked.erase(which)

	
	


