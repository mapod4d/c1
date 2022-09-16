class_name BaseMapodPlayer2D
extends Camera2D


# ----- signals
signal metaverse_requested()
# reguest new scene
signal scene_requested(scene_name)
signal push_scene_requested(scene_name)
signal pop_scene_requested()

# ----- enums

# ----- constants

# ----- exported variables
#debug
export(bool) var debug_flag = false setget set_debug_flag

# ----- public variables
#debug
var defer_debug_flag = false
var speed: Vector2  = Vector2(0, 0)

# ----- private variables
var _width_size = 1920
var _height_size = 1080

# ----- onready variables

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

# ----- public methods

func set_debug_flag(value):
	debug_flag = value
	defer_debug_flag = value


func speed_to_string():
	return "None"


func mapod_set_2d_start_position(mapod_position: Vector2):
	position = mapod_position


func mapod_set_2d_limits(width_size: int, height_size: int):
	_width_size = width_size
	_height_size = height_size

# ----- private methods

func _metaverse_request():
	emit_signal("metaverse_requested")


func _scene_request(scene_name):
	emit_signal("scene_requested", scene_name)


func _push_scene_request(scene_name):
	emit_signal("push_scene_requested", scene_name)


func _pop_scene_request():
	emit_signal("pop_scene_requested")

