extends TextureRect

const FRICTION = 2
var prev_mouse_pos = null

var recent_speeds = []
var current_speed = 0

var user_spinning = false
var user_dragging = false

func reset():
	rect_position = Vector2(408, 44)
	prev_mouse_pos = null
	recent_speeds = []
	current_speed = 0
	user_spinning = false
	user_dragging = false
	
func start_dragging():
	user_dragging = true

func stop_dragging():
	user_dragging = false
	
func _gui_input(input):
	if input is InputEventMouseButton and input.button_index == BUTTON_LEFT:
		user_spinning = input.pressed
		
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position() 
	
	if not prev_mouse_pos:
		prev_mouse_pos = mouse_pos
		return
	
	if user_dragging:
		rect_position += (mouse_pos - prev_mouse_pos)
		
	if user_spinning:
		var radius = mouse_pos - (rect_position + rect_pivot_offset)
		var prev_radius = prev_mouse_pos - (rect_position + rect_pivot_offset)
		rect_rotation += rad2deg(prev_radius.angle_to(radius))
		
		var speed = (mouse_pos - prev_mouse_pos) / delta
		var tangent = -radius.tangent().normalized()
		var tangential_speed = speed.dot(tangent)
		var angular_speed = tangential_speed / radius.length()
		
		recent_speeds.push_front(angular_speed)
		if recent_speeds.size() > 3:
			recent_speeds.resize(3)
		current_speed = null
		
	else:
		if current_speed == null:
			current_speed = 0
			for speed in recent_speeds:
				if abs(speed) > abs(current_speed):
					current_speed = speed
			recent_speeds = []
		
		rect_rotation += rad2deg(current_speed * delta)
		
		if current_speed > 0:
			current_speed = max(0, current_speed - delta * FRICTION)
		else:
			current_speed = min(0, current_speed + delta * FRICTION)
			
	prev_mouse_pos = mouse_pos
