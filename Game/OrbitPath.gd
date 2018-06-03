extends Node2D

# Draws a basic circle to represent the orbital path.
# If orbits are ever refactored to be capable of elipical orbits, this will also require a rewrite.

#func draw_empty_circle(Vector2 circle_center, Vector2 circle_radius, Color color, int resolution):
# Taken from https://www.reddit.com/r/godot/comments/3ktq39/drawing_empty_circles_and_curves/
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

func _draw():
	draw_empty_circle(
		#	get_parent().get_parent().position ,
			-get_parent().position,
		#	Vector2(get_parent().orbital_distance * 1000, get_parent().orbital_distance * 1000),
			position - get_parent().position,
			Color(255, 255, 0),
			1
			)


func _process(delta):
	update()

