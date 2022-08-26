class_name AnyFallingBoxInArea
extends Area2D


func get_overlapping_falling_box_body() -> RigidBody2D:
	var bodies: Array = self.get_overlapping_bodies()

	for body in bodies:
		if body is RigidBody2D and body.is_in_group("falling_box"):
			return body

	return null


func get_overlapping_falling_box_bodies() -> Array:
	var bodies: Array = self.get_overlapping_bodies()
	var falling_boxes: Array = []

	for body in bodies:
		if body is RigidBody2D and body.is_in_group("falling_box"):
			falling_boxes.append(body)

	return falling_boxes
