extends CollisionShape2D


func _ready():
	var _err = get_tree().get_root().connect("size_changed", self, "update")

func update():
	shape.set_extents(Vector2(OS.window_size.x / 2,10))
	position.y = OS.window_size.y + shape.extents.y
	position.x = OS.window_size.x / 2
	get_node("../../Light2D").position.x = OS.window_size.x / 2
