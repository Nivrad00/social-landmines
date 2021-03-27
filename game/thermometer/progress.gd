extends TextureProgress



func _ready():
	pass 
	
func update_mood(new_value):
	get_node("progress").value = new_value
	
