extends AnyFallingBoxInArea


func _physics_process(_delta) -> void:
	global_transform.origin = get_global_mouse_position()
