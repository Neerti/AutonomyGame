extends Position2D

# This piece taken from https://www.reddit.com/r/godot/comments/3ktq39/drawing_empty_circles_and_curves/
func draw_empty_circle(circle_center, circle_radius, color, resolution):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center

	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_radius.rotated(deg2rad(360)) + circle_center
	draw_line(line_origin, line_end, color)

#
#func _draw():
#	for child in get_children():
#		var orbital_class = load("res://Orbital.gd")
#		if child is orbital_class:
#			var dist = child.position - position
#			print(dist)
#			draw_empty_circle(
#					position ,
#					dist,
#					Color(255, 255, 0),
#					1
#					)
#
## TODO: Remove later.
#func _process(delta):
#	update()