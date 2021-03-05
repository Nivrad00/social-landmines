extends Dialogue

onready var f = Rakugo.define_character("Farmer 1", "f", Color.aqua)
onready var player_ch = Rakugo.define_character("Player-kun", "player", Color.green)

func _ready() -> void:
	Rakugo.define_character("Me", "m", Color.pink)

const beans = 1
const toilet = 2

func Dialogue():
	start_event("Dialogue")
	show("bg seed")
	
	

	
	say(f, "What do you want?", {"typing":false})
	step()
	
	var choice = menu([
		["I want to buy some beans", beans, {}],
		["Can I use the restroom.", toilet, {}],
	])
	
	if cond(choice == beans):
		$beans.start()

	elif cond(choice == toilet):
		$restroom.start()
	
	end_event()
