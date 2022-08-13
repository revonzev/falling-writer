extends Node2D

onready var _window_floor := $WindowFloor
onready var _window_floor_shape := $WindowFloor/CollisionShape2D
onready var _sun := $Sun


func _ready():
	var _err = get_tree().get_root().connect("size_changed", self, "_window_updated")


func _window_updated():
	_window_floor_shape.shape.set_extents(Vector2(OS.window_size.x / 2,10))
	_window_floor.position.y = OS.window_size.y + _window_floor_shape.extents.y
	_window_floor.position.x = OS.window_size.x / 2
	_sun.position.x = OS.window_size.x / 2
