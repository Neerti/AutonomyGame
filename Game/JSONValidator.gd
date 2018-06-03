extends Node

var file_to_test = null

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var dict = {}

func _ready():
	var file = File.new()
	file.open("res://Data/default_galaxy.json", file.READ)
	var text = file.get_as_text()
	file.close()
	
	
	var result_json = JSON.parse(text)
	var result = {}
	
	if result_json.error == OK: # Nothing wrong.
		var data = result_json.result
		print("JSON file successfully parsed.")
		print(data)
	else: # Something is wrong.
		printerr("Error: ", result_json.error)
		printerr("Error Line: ", result_json.error_line)
		printerr("Error String: ", result_json.error_string)
