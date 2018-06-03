extends Node2D

const ORBIT_COLOR = Color(255, 255, 0) # Yellow.
const ORBIT_QUALITY = 0.25

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
	draw_set_transform(-get_parent().position, 0.0, Vector2(1, 1))
	
	var dist = position - get_parent().position
	draw_empty_circle(
			position,
			dist,
			ORBIT_COLOR,
			ORBIT_QUALITY
			)
	# If a way to not redraw the circle constantly is found, uncomment this.
	#if dist.x != 0:
	#	set_process(false)

# Potential optimization would be to remove the need to constantly redraw the circle when the orbiter moves.
# That might not be possible, however.
func _process(delta):
	update()

