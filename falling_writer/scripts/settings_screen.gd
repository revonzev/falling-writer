extends VBoxContainer

var setting_scn := preload("res://falling_writer/components/setting.tscn")
var items := {}


func _ready():
	var settings := UserSettings.get_settings()
	for setting in settings:
		items[setting] = setting_scn.instance()
		add_child(items[setting])
		items[setting].set_setting(setting)


func _on_SettingsScreen_popup_hide():
	for item in items:
		if not item in ["Settings version", "Software version"]:
			UserSettings.set_setting(item, items[item].get_value())
	print(UserSettings.get_settings())
	UserSettings.write_settings()


func _on_CloseButton_pressed():
	owner.hide()
