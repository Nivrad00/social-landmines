extends VBoxContainer

var checked = []

func _ready():
	
	$Checkboxes/girlfriend.connect("toggled",self,"limit_checks",[$Checkboxes/girlfriend])
	$Checkboxes/boyfriend.connect("toggled",self,"limit_checks",[$Checkboxes/boyfriend])
	$Checkboxes/partner.connect("toggled",self,"limit_checks",[$Checkboxes/partner])
	$Checkboxes/school.connect("toggled",self,"limit_checks",[$Checkboxes/school])
	$Checkboxes/art.connect("toggled",self,"limit_checks",[$Checkboxes/art])
	$Checkboxes/sports.connect("toggled",self,"limit_checks",[$Checkboxes/sports])
	$Checkboxes/theater.connect("toggled",self,"limit_checks",[$Checkboxes/theater])
	$Checkboxes/popularity.connect("toggled",self,"limit_checks",[$Checkboxes/popularity])
	$Checkboxes/friendships.connect("toggled",self,"limit_checks",[$Checkboxes/friendships])


func limit_checks(button_pressed,which):
	if(checked.size()<2 && button_pressed == true):
		checked.append(which)
	elif(checked.size() == 2 && button_pressed == true):
		checked[0].set_pressed(false)
		checked.append(which)
	elif(button_pressed == false):
		checked.erase(which)

	
	


