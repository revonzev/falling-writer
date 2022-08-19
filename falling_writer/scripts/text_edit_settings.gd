extends ColorRect

enum _BtnTypes {INCREASE, DECREASE, NEW, SAVE, LOAD, SETTINGS}

export(_BtnTypes) var _type
export(Texture) var _icon_img_path

var _file_path := ""

onready var _text_edit: TextEdit = get_node("../../TextEdit")
onready var _file_dialog: FileDialog = get_node("%FileDialog")
onready var _settings_screen: Popup = get_node("%SettingsScreen")


func _ready() -> void:
	var _err = UserSettings.connect("settings_written", self, "_settings_changed")
	_settings_changed()

	$Sprite.texture = _icon_img_path
	
	match _type:
		_BtnTypes.INCREASE:
			hint_tooltip = "Increase Text Size (CTRL+-)"
		_BtnTypes.DECREASE:
			hint_tooltip = "Decrease Text Size (CTRL++)"
		_BtnTypes.NEW:
			hint_tooltip = "New File (CTRL+N)"
		_BtnTypes.SAVE:
			hint_tooltip = "Save File (CTRL+S)"
		_BtnTypes.LOAD:
			hint_tooltip = "Load File (CTRL+O)"
		_BtnTypes.SETTINGS:
			hint_tooltip = "Open Settings Menu (ESC)"
		
	_resize_font(UserSettings.get_setting("Text editor font size"))


func _unhandled_input(event):
	if event.is_action_pressed("save_file") and _type == _BtnTypes.SAVE:
		_sprite_pressed_effect()
		_new_or_save_file()
	elif event.is_action_pressed("open_file") and _type == _BtnTypes.LOAD:
		_sprite_pressed_effect()
		_file_dialog.mode = FileDialog.MODE_OPEN_FILE
		_file_dialog.popup()
	elif event.is_action_pressed("new_file") and _type == _BtnTypes.NEW:
		_sprite_pressed_effect()
		_file_dialog.mode = FileDialog.MODE_SAVE_FILE
		_file_dialog.popup()
	elif event.is_action_pressed("decrease_font_size") and _type == _BtnTypes.DECREASE:
		_sprite_pressed_effect()
		_resize_font(int(max(4, UserSettings.get_setting("Text editor font size") - 4)))
	elif event.is_action_pressed("increase_font_size") and _type == _BtnTypes.INCREASE:
		_sprite_pressed_effect()
		_resize_font(UserSettings.get_setting("Text editor font size")+4)
	elif event.is_action_pressed("open_settings") and _type == _BtnTypes.SETTINGS:
		if _settings_screen.visible:
			_settings_screen.hide()
		else:
			_settings_screen.popup()


func shortcuts(key: String) -> void:
	match key:
		"save":
			_new_or_save_file()
		"open":
			_file_dialog.mode = FileDialog.MODE_OPEN_FILE
			_file_dialog.popup()


func _settings_changed() -> void:
	_resize_font(UserSettings.get_setting("Text editor font size"))


func _sprite_pressed_effect() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("pressed")


func _new_or_save_file() -> void:
	if _file_path != "":
		_save_data(_text_edit.text, _file_path)
	else:
		_file_dialog.mode = FileDialog.MODE_SAVE_FILE
		_file_dialog.popup()


func _resize_font(value: int) -> void:
	UserSettings.set_setting("Text editor font size", value)
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://fonts/Roboto-Regular.ttf")
	dynamic_font.size = UserSettings.get_setting("Text editor font size")
	_text_edit.set("custom_fonts/font", dynamic_font)


func _save_data(content: String, path: String) -> void:
	var file := File.new()
	var _err: int = file.open(path, File.WRITE)
	file.store_string(content)
	file.close()


func _load_data(path: String) -> String:
	var file := File.new()
	var _err: int = file.open(path, File.READ)
	var content := file.get_as_text()
	file.close()
	return content


func _on_FileDialog_file_selected(path: String) -> void:
	match _file_dialog.mode:
		FileDialog.MODE_SAVE_FILE:
			_save_data(_text_edit.text, path)
		FileDialog.MODE_OPEN_FILE:
			_text_edit.text = _load_data(path)

	_file_path = path



func _on_TextEditFontResize_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.get_button_index() == 1 \
			and event.pressed:
		match _type:
			_BtnTypes.INCREASE:
				_resize_font(UserSettings.get_setting("Text editor font size")+4)
			_BtnTypes.DECREASE:
				_resize_font(int(max(4, UserSettings.get_setting("Text editor font size") - 4)))
			_BtnTypes.NEW:
				_file_dialog.mode = FileDialog.MODE_SAVE_FILE
				_file_dialog.popup()
			_BtnTypes.SAVE:
				_new_or_save_file()
			_BtnTypes.LOAD:
				_file_dialog.mode = FileDialog.MODE_OPEN_FILE
				_file_dialog.popup()
			_BtnTypes.SETTINGS:
				_settings_screen.popup()
		_sprite_pressed_effect()
