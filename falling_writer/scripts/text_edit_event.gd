extends Control

export(Array, Resource) var typing_sounds
export(Resource) var falling_label_box

onready var text_edit: TextEdit = get_node("%TextEdit")
onready var node_2d: Node2D = get_node("%Node2D")
onready var audio: AudioStreamPlayer = get_node("%AudioStreamPlayer")
onready var word_count: Label = get_node("%WordCount/Label")
onready var char_count: Label = get_node("%CharCount/Label")


func _ready():
	OS.min_window_size = get_tree().get_root().get_node("FallingWriter").rect_min_size
	randomize()


func _on_TextEdit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.unicode > 20 and event.unicode < 126:
			var FallingLabelBox = falling_label_box.instance()

			FallingLabelBox.get_node("Label").text = char(event.unicode)
			FallingLabelBox.position.x = rand_range(0, OS.window_size.x)
			FallingLabelBox.position.y = -FallingLabelBox.get_node("ColorRect").rect_size.x / 2

			node_2d.add_child(FallingLabelBox)

		audio.stream = typing_sounds[randi() % typing_sounds.size()]
		audio.play()

		update_word_count()
		update_char_count()


func update_word_count() -> void:
	var regex := RegEx.new()
	var _err = regex.compile("\\S+")
	var result := regex.search_all(text_edit.text)
	word_count.text = str(result.size())
	
	
func update_char_count() -> void:
	char_count.text = str(text_edit.text.length())
