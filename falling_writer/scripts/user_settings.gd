extends Node

signal settings_written

var user_settings: Dictionary = get_default() setget set_settings, get_settings


func _ready() -> void:
	var loaded_settings := user_settings
	
	if _settings_file_exist():
		loaded_settings = _load_settings()
	
	# Old to new user settings
	if user_settings["Settings version"] != loaded_settings["Settings version"]:
		write_settings(_get_settings_file_path() + ".old", loaded_settings)
		
		loaded_settings["Settings version"] = user_settings["Settings version"]
		
		for key in loaded_settings:
			if not key in user_settings.keys():
				var _err = loaded_settings.erase(key)

	loaded_settings["Software version"] = user_settings["Software version"]
	user_settings.merge(loaded_settings, true)
	write_settings()


func get_default() -> Dictionary:
	return {
		"Settings version": 0,
		"Software version": "1.1.0",
		"Falling box": true,
		"Falling box color": "#eea243",
		"Falling box text color": "#000000",
		"Sun": 1.0,
		"Text editor font size": 16,
		"Typing sounds": true,
	}
	

func set_setting(key: String, value) -> void:
	user_settings[key] = value
	

func get_setting(key):
	if user_settings.has(key):
		return user_settings[key]
	else:
		user_settings[key] = get_default()[key]
		write_settings()
		return user_settings[key]
	

func set_settings(data: Dictionary) -> void:
	for key in data:
		if key in user_settings.keys():
			user_settings[key] = data[key]
	

func get_settings() -> Dictionary:
	return user_settings
	


func write_settings(file_path := _get_settings_file_path(), data := user_settings) -> void:
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(JSON.print(data, "\t", true))
	file.close()
	emit_signal("settings_written")
	

func _settings_file_exist() -> bool:
	var file = File.new()
	return file.open(_get_settings_file_path(), File.READ) == OK


func _load_settings() -> Dictionary:
	var file = File.new()
	file.open(_get_settings_file_path(), File.READ)
	var content = parse_json(file.get_as_text())
	file.close()
	return content


func _get_settings_file_path() -> String:
	if OS.is_debug_build():
		return "user://user_settings.json"
	else:
		return "./user_settings.json"