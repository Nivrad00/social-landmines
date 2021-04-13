extends VBoxContainer


export (NodePath) var dropdown_path
onready var dropdown = get_node(dropdown_path)



# Called when the node enters the scene tree for the first time.
func _ready():
	add_items()

func add_items():
	dropdown.add_item("He/His/Him")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
