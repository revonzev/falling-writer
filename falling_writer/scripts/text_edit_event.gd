extends TextEdit

export(Array, Resource) var typing_sounds
export(Resource) var falling_label_box


func _ready():
	OS.min_window_size = get_tree().get_root().get_node("FunTextEditor").rect_min_size
	randomize()


func _on_TextEdit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.unicode > 20 and event.unicode < 126:
			var FallingLabelBox = falling_label_box.instance()

			FallingLabelBox.get_node("Label").text = char(event.unicode)
			FallingLabelBox.position.x = rand_range(0, OS.window_size.x)
			FallingLabelBox.position.y = -FallingLabelBox.get_node("ColorRect").rect_size.x / 2

			get_node("../../../../Node2D").add_child(FallingLabelBox)

		get_node("../../../../AudioStreamPlayer").stream = typing_sounds[randi() % typing_sounds.size()]
		get_node("../../../../AudioStreamPlayer").play()

		update_word_count()


func update_word_count() -> void:
	var regex := RegEx.new()
	var _err = regex.compile("\\S+")
	var result := regex.search_all(text)
	get_node("../HBoxContainer/WordCount/Label").text = str(result.size())
