extends Node

const FILE_PATH = "./user_settings.json"
const OLD_FILE_PATH = "./user_settings.json.old"

var user_settings: Dictionary = get_default() setget set_settings, get_settings


func _ready() -> void:
	var loaded_settings := user_settings
	
	if settings_file_exsist():
		loaded_settings = load_settings()
	else:
		write_settings()
	
	# Old to new user settings
	if user_settings["settings_version"] != loaded_settings["settings_version"]:
		write_settings(OLD_FILE_PATH, loaded_settings)
		
		for key in ["settings_version", "software_version"]:
			var _err = loaded_settings.erase(key)

		loaded_settings.merge(user_settings)
		
		for key in loaded_settings:
			if not key in user_settings.keys():
				var _err = loaded_settings.erase(key)
		
		user_settings = loaded_settings
		write_settings()


func get_default() -> Dictionary:
	return {
		"settings_version": 0,
		"software_version": "1.0.0",
	}
	

func set_setting(key: String, value) -> void:
	user_settings[key] = value
	

func get_setting(key):
	return user_settings[key]
	

func set_settings(data: Dictionary) -> void:
	for key in data:
		if key in user_settings.keys():
			user_settings[key] = data[key]
	

func get_settings() -> Dictionary:
	return user_settings
	

func load_settings() -> Dictionary:
	var file = File.new()
	file.open(FILE_PATH, File.READ)
	var content = parse_json(file.get_as_text())
	file.close()
	return content
	

func write_settings(file_path := FILE_PATH, data := user_settings) -> void:
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(JSON.print(data, "\t", true))
	file.close()
	

func settings_file_exsist() -> bool:
	var file = File.new()
	return file.open(FILE_PATH, File.READ) == OK
