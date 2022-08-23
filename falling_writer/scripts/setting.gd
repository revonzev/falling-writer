extends PanelContainer

enum _inputs { LABEL, STRING, INTEGER, DECIMAL, COLOR, BOOL }

onready var _key_label: Label = get_node("%KeyLabel")
onready var _text_edit: TextEdit = get_node("%TextEdit")
onready var _color_picker: ColorPickerButton = get_node("%ColorPickerButton")
onready var _check_btn: CheckButton = get_node("%CheckButton")
onready var _value_label: Label = get_node("%ValueLabel")
onready var _reset_btn: Button = get_node("%ResetButton")

export(_inputs) var _input = _inputs.LABEL
var _key := ""


func set_setting(key := _key):
	_key = key
	_key_label.text = _key
	_set_value(UserSettings.get_setting(_key))


func get_value():
	if _input == _inputs.STRING:
		return _text_edit.get_text()
	elif _input == _inputs.COLOR:
		return "#" + Color(_color_picker.get_pick_color()).to_html(false)
	elif _input == _inputs.INTEGER:
		return int(_text_edit.get_text())
	elif _input == _inputs.DECIMAL:
		return float(_text_edit.get_text())
	elif _input == _inputs.BOOL:
		return bool(_check_btn.pressed)


func _on_ResetButton_pressed():
	var default = UserSettings.get_default()[_key]
	if _input == _inputs.STRING:
		_text_edit.set_text(str(default))
	elif _input == _inputs.COLOR:
		_color_picker.set_pick_color(Color(default))
	elif _input == _inputs.INTEGER:
		_text_edit.set_text(str(default))
	elif _input == _inputs.DECIMAL:
		_text_edit.set_text(str(default))
	elif _input == _inputs.BOOL:
		_check_btn.pressed = default


func _set_value(value):
	if _key in ["Settings version", "Software version"]:
		_value_label.show()
		_value_label.set_text(str(value))
		_input = _inputs.LABEL
		_reset_btn.hide()
	elif value is String:
		if value[0] != "#":
			_text_edit.show()
			_text_edit.set_text(str(value))
			_input = _inputs.STRING
		else:
			_color_picker.show()
			_color_picker.set_pick_color(Color(value))
			_input = _inputs.COLOR
	elif value is int:
		_text_edit.show()
		_text_edit.set_text(str(value))
		_input = _inputs.INTEGER
	elif value is float:
		_text_edit.show()
		_text_edit.set_text(str(value))
		_input = _inputs.DECIMAL
	elif value is bool:
		_check_btn.show()
		_check_btn.pressed = value
		_input = _inputs.BOOL
