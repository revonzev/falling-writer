extends ColorRect

enum Type {INCREASE, DECREASE, NEW, SAVE, LOAD}
export(Type) var type
export(int) var font_size = 16
export(NodePath) onready var sync_node_font_size
export(Texture) var icon_img_path
var file_path := ""

onready var text_edit = get_node("../../TextEdit")
onready var file_dialog = get_node("%FileDialog")


func _ready() -> void:
	$Sprite.texture = icon_img_path
	
	match type:
		Type.INCREASE:
			hint_tooltip = "Increase Text Size"
		Type.DECREASE:
			hint_tooltip = "Decrease Text Size"
		Type.NEW:
			hint_tooltip = "New File"
		Type.SAVE:
			hint_tooltip = "Save File"
		Type.LOAD:
			hint_tooltip = "Load File"


func _on_TextEditFontResize_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.get_button_index() == 1 \
			and event.pressed:
		match type:
			Type.INCREASE:
				font_size += 2
				_resize_font()
			Type.DECREASE:
				font_size = max(2, font_size - 2)
				_resize_font()
			Type.NEW:
				file_dialog.mode = FileDialog.MODE_SAVE_FILE
				file_dialog.popup()
			Type.SAVE:
				new_or_save_file()
			Type.LOAD:
				file_dialog.mode = FileDialog.MODE_OPEN_FILE
				file_dialog.popup()


func new_or_save_file() -> void:
	if file_path != "":
		save_data(text_edit.text, file_path)
	else:
		file_dialog.mode = FileDialog.MODE_SAVE_FILE
		file_dialog.popup()


func _resize_font() -> void:
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://fonts/Roboto-Regular.ttf")
	dynamic_font.size = font_size
	text_edit.set("custom_fonts/font", dynamic_font)
	get_node(sync_node_font_size).font_size = font_size


func shortcuts(key: String) -> void:
	match key:
		"save":
			new_or_save_file()
		"open":
			file_dialog.mode = FileDialog.MODE_OPEN_FILE
			file_dialog.popup()


func save_data(content: String, path: String) -> void:
	var file := File.new()
	var _err: int = file.open(path, File.WRITE)
	file.store_string(content)
	file.close()


func load_data(path: String) -> String:
	var file := File.new()
	var _err: int = file.open(path, File.READ)
	var content := file.get_as_text()
	file.close()
	return content


func _on_FileDialog_file_selected(path: String) -> void:
	match file_dialog.mode:
		FileDialog.MODE_SAVE_FILE:
			save_data(text_edit.text, path)
		FileDialog.MODE_OPEN_FILE:
			text_edit.text = load_data(path)

	file_path = path
