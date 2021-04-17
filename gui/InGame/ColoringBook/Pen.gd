extends Control

var to_draw = []
var to_erase = false
var color = null
	
func _on_draw():
	if to_draw.size() > 0:
		if to_draw[0]:
			draw_line(to_draw[0], to_draw[1], color, 6, true)
		draw_circle(to_draw[1], 4, color)
		to_draw = []
	
	if to_erase:
		draw_rect(Rect2(0, 0, 10000, 10000), Color(1, 1, 1), true)
		to_erase = false
		
func _process(delta):
	update()
