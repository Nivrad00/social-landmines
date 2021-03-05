extends Dialogue

func sale():
	start_event("sale")
	
	say("f", "That'd be 300 buckeroos")
	step()
	
	Rakugo.reset_game()
	exit()
