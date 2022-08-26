extends Node2D

onready var _window_floor: StaticBody2D = $WindowFloor
onready var _window_floor_shape: Shape2D = $WindowFloor/CollisionShape2D.shape
onready var _sun: Light2D = $Sun


func _ready():
	var _err = get_tree().get_root().connect("size_changed", self, "_window_updated")

	_err = UserSettings.connect("settings_written", self, "_settings_changed")
	_settings_changed()


func _window_updated():
	_window_floor_shape.set_extents(Vector2(OS.window_size.x / 2, 10))
	_window_floor.position.y = OS.window_size.y + _window_floor_shape.extents.y
	_window_floor.position.x = OS.window_size.x / 2
	_sun.position.x = OS.window_size.x / 2


func _settings_changed():
	UserSettings.set_setting("Sun", clamp(UserSettings.get_setting("Sun"), 0, 16))
	_sun.energy = UserSettings.get_setting("Sun")


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var body: RigidBody2D = $Mouse.get_overlapping_falling_box_body()

		if body:
			body.explode()
