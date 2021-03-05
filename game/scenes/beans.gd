extends Dialogue

const inches = 1
const tons = 2

func beans():
	start_event("beans")
	
	say("f","How many beans do you want?", {"typing":false})
	
	var choice = menu([
		["200 cubic inches.", inches, {}],
		["20 metric tons.", tons, {}],
	])
	
	$sale.start()
	end_event()
