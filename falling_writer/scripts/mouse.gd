extends Area2D


func _physics_process(_delta) -> void:
	global_transform.origin = get_global_mouse_position()


func get_overlapping_falling_box_body() -> RigidBody2D:
	var bodies: Array = self.get_overlapping_bodies()

	for body in bodies:
		if body is RigidBody2D and body.is_in_group("falling_box"):
			return body

	return null
