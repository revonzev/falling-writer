extends RigidBody2D


func _ready():
	var _err = UserSettings.connect("settings_written", self, "_settings_changed")
	_settings_changed()


func _on_Timer_timeout() -> void:
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	queue_free()


func _settings_changed():
	$ColorRect.color = Color(UserSettings.get_setting("Falling box color"))
	$Label.modulate = Color(UserSettings.get_setting("Falling box text color"))
