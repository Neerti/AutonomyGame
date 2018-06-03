extends Node2D

# This implements a fake circular orbit around the node's parent.
# Maybe someday it can be refactored to include ellipical orbits.
# This can be used for planets, moons, space stations, and anything else.

# Physics constants;

# Mass
# Might scale up the base unit from kg to something larger.
const SOLAR_MASS = 1.98855 * pow(10, 30) # kg
const EARTH_MASS = 5.9722 * pow(10, 24) # kg
const LUNAR_MASS = 7.3459 * pow(10, 22) # kg

# Distance.
const ASTRONOMICAL_UNIT = 149597870700.0 # km
const PIXELS_PER_AU = 1000

# Speed.
const SPEED_OF_LIGHT = 299792.458 # km

# Time.
const DAYS_IN_YEAR = 365.25

const ORBIT_SPEED_MULTIPLIER = 1

var parent = null # Node's parent, stored to save fetching it constantly.

export (bool) var retrograde = false # If true, will rotate in reverse.

export (float) var orbital_distance = 1 # How far from parent to orbit to, in AU. In-game, PIXELS_PER_AU is also used.

var _orbital_period = 365 # How long it takes to orbit once.
var _current_angle = 0 # Radians.
export (float) var _initial_angle = null # Ditto.

var time = 0 # Todo: Remove in favor of universal time.

func setup(_name, _distance):
	name = _name
	orbital_distance = _distance

func _ready():
	parent =  get_parent()
	if(orbital_distance == 0): # Static orbital (Most likely the star).
		set_process(false)
		return
	
	_orbital_period = calculate_orbital_period(orbital_distance)
	if(_initial_angle == null):
		_initial_angle = TAU * randf() # Randomize the starting angle if not set.
	print(str(_orbital_period))

# Todo: Remove this
# Later on this will get processed as needed when within a certain distance of the player's camera.
# Since the angle is based on a time value, nothing will be lost if the orbit stops updating offscreen.
func _process(delta):
	time += (delta * ORBIT_SPEED_MULTIPLIER)
	calculate_angle(time / DAYS_IN_YEAR)
	update_orbital_position()

func update_orbital_position():
	var pos = Vector2(
			sin(_current_angle + _initial_angle) * orbital_distance * PIXELS_PER_AU,
			cos(_current_angle + _initial_angle) * orbital_distance * PIXELS_PER_AU
			)
	position = pos

# One t is equal to one year.
func calculate_angle(t):
	if(retrograde):
		t = -t
	_current_angle = (t / _orbital_period) * TAU

# Returns orbital period.
# Input must be in AU.
# Output is in years.
func calculate_orbital_period(distance_from_parent):
	var period = pow(distance_from_parent, 3)
	period = sqrt(period)
	return period

