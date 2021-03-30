extends Dialogue


func question():
	start_event("question")
	
	print(Global.mood)
	say(null,"What is your mood from 0-100?",{"typing":false})
	var mood_ask = ask("",{"placeholder": "Enter mood here"})
	Global.mood = mood_ask
	jump("","MainDialog","")
	end_event()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
