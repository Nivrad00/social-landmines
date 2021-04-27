extends Dialogue


func question():
	start_event("question")
	
	print(Global.get_var('mood'))
	jump("","MainDialog","")
	end_event()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
