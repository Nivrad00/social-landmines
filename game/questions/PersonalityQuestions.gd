extends VBoxContainer

var checked = []

func _ready():
	
	$Checkboxes/Q1.connect("toggled",self,"limit_checks",[$Checkboxes/Q1])
	$Checkboxes/Q2.connect("toggled",self,"limit_checks",[$Checkboxes/Q2])
	$Checkboxes/Q3.connect("toggled",self,"limit_checks",[$Checkboxes/Q3])
	$Checkboxes/Q4.connect("toggled",self,"limit_checks",[$Checkboxes/Q4])
	$Checkboxes/Q5.connect("toggled",self,"limit_checks",[$Checkboxes/Q5])
	$Checkboxes/Q6.connect("toggled",self,"limit_checks",[$Checkboxes/Q6])
	$Checkboxes/Q7.connect("toggled",self,"limit_checks",[$Checkboxes/Q7])
	$Checkboxes/Q8.connect("toggled",self,"limit_checks",[$Checkboxes/Q8])
	$Checkboxes/Q9.connect("toggled",self,"limit_checks",[$Checkboxes/Q9])


func limit_checks(button_pressed,which):
	if(checked.size()<2 && button_pressed == true):
		checked.append(which)
	elif(checked.size() == 2 && button_pressed == true):
		checked[0].set_pressed(false)
		checked.append(which)
	elif(button_pressed == false):
		checked.erase(which)

	
	


