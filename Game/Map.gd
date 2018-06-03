extends Node

var default_galaxy_path = "res://Data/test_galaxy.json"

func _ready():
	generate_map_from_dict(load_json(default_galaxy_path))

# TODO: Make global?
func load_json(path):
	var file = File.new()
	
	if not file.file_exists(path):
		printerr("load_json() failed, file not found: ", path)
		return
	
	file.open(path, file.READ)
	var text = file.get_as_text()
	file.close()
	
	var result_json = JSON.parse(text)
	
	if result_json.error == OK:
		var data = result_json.result
		print("JSON file successfully parsed.")
		print(data)
		return result_json.result
	
	else: # Something went wrong.
		printerr("Error: ", result_json.error)
		printerr("Error Line: ", result_json.error_line)
		printerr("Error String: ", result_json.error_string)
		return


func generate_map_from_dict(dict):
	if typeof(dict) != TYPE_DICTIONARY:
		printerr("Error: generate_map_from_dict(): Was not given dictionary input.")
		return
	
	var solar_systems = dict["solar_systems"]
	for key in solar_systems:
		print(key, " -> ", solar_systems[key])
		build_system_from_dict(key, solar_systems[key])


# Builds star systems from a dictionary.
func build_system_from_dict(new_name, dict):
		# Make the system object.
		var system_scene = preload("res://System.tscn")
		var new_system = system_scene.instance()
		add_child(new_system)
		
		# Get all the star system variables.
		var new_pos = Vector2(dict["pos_x"], dict["pos_y"])
		print(new_name, "@", new_pos)
		
		# Write them to the new system.
		# TODO: Move into constructor args?
		new_system.position = new_pos
		new_system.name = new_name
		
		# Iterate over orbitals and make them.
		# If the orbitals that are made have their own orbitals (moons), they will also be created.
		if dict.has("orbitals"):
			var new_orbitals = dict["orbitals"]
			for orbital in new_orbitals:
				print(orbital, " -> ", new_orbitals[orbital])
				var new_orbital = build_orbital_from_dict(orbital, new_orbitals[orbital])
				new_system.add_child(new_orbital)

# Builds objects which orbit systems or other orbitals.
# TODO: Rewrite to be less copypasta.
func build_orbital_from_dict(new_name, dict):
	# Make the orbital object.
	# TODO: Make this not hardcoded?
	var orbital_scene = preload("res://Orbital.tscn")
	var new_orbital = orbital_scene.instance()
	new_orbital.setup(new_name, dict["distance"])
	
	# TODO: Constructor?
	if dict.has("scale"):
		# Note, DO NOT scale the base object, or it will mess up a lot of things.
		new_orbital.scale_sprite(Vector2(dict["scale"], dict["scale"]))
	if dict.has("angle"):
		new_orbital.initial_angle = dict["angle"]
	
	# Make orbitals, if any exist.
	if dict.has("orbitals"):
		var new_orbitals = dict["orbitals"]
		for orbital in new_orbitals:
			var new_sub_orbital = build_orbital_from_dict(orbital, new_orbitals[orbital])
			new_orbital.add_child(new_sub_orbital)
	
	return new_orbital