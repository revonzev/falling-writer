extends RigidBody2D

onready var explosion_area: Area2D = $Explosion/Area2D


func _ready():
	var _err = UserSettings.connect("settings_written", self, "_settings_changed")
	_settings_changed()


func explode():
	var bodies_in_explosion: Array = explosion_area.get_overlapping_falling_box_bodies()

	self.mode = MODE_STATIC

	for body in bodies_in_explosion:
		var direction = (body.position - self.position).normalized()
		var knockback = 1000 * (1 - clamp(body.position.distance_to(self.position) / 150, 0, 1))
		body.set_linear_velocity(direction * knockback)

	self.queue_free()


func _on_Timer_timeout() -> void:
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	queue_free()


func _settings_changed():
	$ColorRect.color = Color(UserSettings.get_setting("Falling box color"))
	$Label.modulate = Color(UserSettings.get_setting("Falling box text color"))
