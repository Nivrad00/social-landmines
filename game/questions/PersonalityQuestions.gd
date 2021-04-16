extends VBoxContainer

var checked = []

func _ready():
	
	$Checkboxes/CheckBox.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox])
	$Checkboxes/CheckBox2.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox2])
	$Checkboxes/CheckBox3.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox3])
	$Checkboxes/CheckBox4.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox4])
	$Checkboxes/CheckBox5.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox5])
	$Checkboxes/CheckBox6.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox6])
	$Checkboxes/CheckBox7.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox7])
	$Checkboxes/CheckBox8.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox8])
	$Checkboxes/CheckBox9.connect("toggled",self,"limit_checks",[$Checkboxes/CheckBox9])


func limit_checks(button_pressed,which):
	if(checked.size()<2 && button_pressed == true):
		checked.append(which)
	elif(checked.size() == 2 && button_pressed == true):
		checked[0].set_pressed(false)
		checked.append(which)
	elif(button_pressed == false):
		checked.erase(which)

	
	


