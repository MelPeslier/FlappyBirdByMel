extends Node

const SAVE_GAME_PATH = "user://savegame.save"

var save_it : ToSave 

func _ready():
	save_it = ToSave.new()
	load_game()

func save_game():
	var to_save_game = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	
	# Call the node's save function.
	var data_to_save = save_it.call("save")
	
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(data_to_save)
	
	# Store the save dictionary as a new line in the save file.
	to_save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists(SAVE_GAME_PATH):
		print("shit")
		return
	
	var to_save_game = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	
	#while save_game.get_position() < save_game.get_length():
	var json_string = to_save_game.get_line()
	
	var json = JSON.new()
	
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	
	# Get the data from the JSON object
	var data_to_load = json.get_data()
	
	# work too : data_to_load.high_score
	save_it.set_high_score(data_to_load["high_score"])



