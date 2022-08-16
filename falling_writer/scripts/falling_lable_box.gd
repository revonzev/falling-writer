extends RigidBody2D


func _ready():
	$ColorRect.color = Color(UserSettings.get_setting("Falling box color"))
	$Label.modulate = Color(UserSettings.get_setting("Falling box text color"))


func _on_Timer_timeout() -> void:
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	queue_free()
