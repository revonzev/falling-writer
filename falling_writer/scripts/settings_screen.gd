extends Popup

const setting_scn := preload("res://falling_writer/components/setting.tscn")

var items := {}

onready var settings_container = get_node("%SettingsContainer")


func _ready():
	var settings := UserSettings.get_settings()
	for setting in settings:
		items[setting] = setting_scn.instance()
		settings_container.add_child(items[setting])
		items[setting].set_setting(setting)


func _on_SettingsScreen_popup_hide():
	for item in items:
		if not item in ["Settings version", "Software version"]:
			UserSettings.set_setting(item, items[item].get_value())
	UserSettings.write_settings()


func _on_CloseButton_pressed():
	hide()


func _on_SettingsScreen_about_to_show():
	for item in items:
		items[item].set_setting()
