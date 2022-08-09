extends RigidBody2D


func _on_Timer_timeout() -> void:
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	queue_free()
