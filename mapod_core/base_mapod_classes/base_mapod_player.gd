class_name BaseMapodPlayer
extends KinematicBody


# ----- signals
signal metaverse_requested()
# request new scene
signal scene_requested(scene_name)
signal push_scene_requested(scene_name)
signal pop_scene_requested()
signal set_panorama_requested(stream_texture)
# first interaction from object
signal object_first_interaction_requested(object_uid)
# second interaction from object
signal object_second_interaction_requested(object_uid)

# ----- enums

# ----- constants

# ----- exported variables
#debug
export(bool) var debug_flag = false setget set_debug_flag

# ----- public variables
#debug
var defer_debug_flag = false
var speed: Vector3  = Vector3(0, 0, 0)

# ----- private variables

# ----- onready variables

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

# ----- public methods

func set_debug_flag(value):
	debug_flag = value
	defer_debug_flag = value


func speed_to_string():
	return "{x}, {y}, {z}".format({
		"x": speed.x, "y": speed.y, "z": speed.z,
	})


func mapod_set_3d_start_position(mapod_position: Array):
	var tr_position = mapod_position[0]
	var tr_angle = mapod_position[1]
	translation = tr_position
	rotation_degrees = tr_angle


func request_panorama(stream_texture):
	emit_signal("set_panorama_requested", stream_texture)

# ----- private methods

func _metaverse_request():
	emit_signal("metaverse_requested")


func _scene_request(scene_name):
	emit_signal("scene_requested", scene_name)


func _push_scene_request(scene_name):
	emit_signal("push_scene_requested", scene_name)


func _pop_scene_request():
	emit_signal("pop_scene_requested")


func _on_set_panorama_requested(stream_texture):
	emit_signal("set_panorama_requested", stream_texture)


func _on_object_first_interaction_requested(object_uid):
	emit_signal("object_first_interaction_requested", object_uid)


func _on_object_second_interaction_requested(object_uid):
	emit_signal("object_second_interaction_requested", object_uid)

