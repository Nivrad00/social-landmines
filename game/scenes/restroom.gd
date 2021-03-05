extends Dialogue


func restroom():
	start_event("restroom")
	
	say("f", "Of course, it is down this way, to the left")
	step()
	
	say("m", "thanks")
	step()
	
	show("bg restroom")
	
	var choice = menu([
		["Go back", "",{}]
	])
	
	jump("","Dialogue","")
	
	end_event()
