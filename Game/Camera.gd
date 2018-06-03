extends Node2D

const CAMERA_SPEED = 1000
const ZOOM_STEP = 0.5
const ZOOM_MIN = 0.5
const ZOOM_MAX = 10.0

func _process(delta):
	var velocity = Vector2()
	
	# X axis.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	
	# Y axis.
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	# Handle velocity normalization.
	if velocity.length() > 0:
		velocity = velocity.normalized() * CAMERA_SPEED * $Camera2D.zoom.x
	
	# Apply velocity to camera.
	position += velocity * delta
	
	# Future: Limit position.
#	position.x = clamp(position.x, 0, screensize.x)
#	position.y = clamp(position.y, 0, screensize.y)

func _input(event):
	# Wheel Up Event
	if event.is_action_pressed("zoom_in"):
		_zoom_camera(-1)
	# Wheel Down Event
	elif event.is_action_pressed("zoom_out"):
		_zoom_camera(1)

# Zoom Camera
func _zoom_camera(dir):
#	$Camera2D.zoom += Vector2(ZOOM_STEP, ZOOM_STEP) * dir
	var clamped_zoom = clamp(
			$Camera2D.zoom.x + ZOOM_STEP * dir,
			ZOOM_MIN,
			ZOOM_MAX
			)
	$Camera2D.zoom = Vector2(clamped_zoom, clamped_zoom)

