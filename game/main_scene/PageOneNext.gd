extends Button

onready var pageOne = get_node("../PageOne")
onready var pageTwo = get_node("../Questions/PageTwo")

func _on_PageOneNext_pressed():
	pageOne.hide()
