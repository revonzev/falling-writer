extends Popup

const _setting_scn: PackedScene = preload("res://falling_writer/components/setting.tscn")

var _items := {}

onready var _settings_container: VBoxContainer = get_node("%SettingsContainer")


func _ready():
	var settings := UserSettings.get_settings()
	for setting in settings:
		_items[setting] = _setting_scn.instance()
		_settings_container.add_child(_items[setting])
		_items[setting].set_setting(setting)


func _on_SettingsScreen_popup_hide():
	for item in _items:
		if not item in ["Settings version", "Software version"]:
			UserSettings.set_setting(item, _items[item].get_value())
	UserSettings.write_settings()


func _on_CloseButton_pressed():
	hide()


func _on_SettingsScreen_about_to_show():
	for item in _items:
		_items[item].set_setting()
