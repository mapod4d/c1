# tool

# class_name
class_name BaseMapod2D3DScene

# extends
extends Node

# # docstring


# ----- signals
signal metaverse_requested()
signal scene_requested(scene_name)
signal push_scene_requested(scene_name)
signal pop_scene_requested()


# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
var start_scene_name = null
var readyStatus = false

# ----- private variables
var _mapod_objects = []

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	var mapod_objects = get_tree().get_nodes_in_group("mapod_objects")
	var unique_id = 1
	for element in mapod_objects:
		if element is BaseMapodObject:
			element.assign_unique_id(unique_id)
			_mapod_objects.append(element)
			element.connect("object_action_requested", self, "_on_object_action_requested")
			unique_id += 1
	readyStatus = true

# ----- remaining built-in virtual methods

# ----- public methods

func isReadyStatus():
	while readyStatus == false:
		pass
	yield()


func mapod_metaverse_request():
	emit_signal("metaverse_requested")


func mapod_scene_request(scene_name):
	emit_signal("scene_requested", scene_name)


func mapod_push_scene_request(scene_name):
	emit_signal("push_scene_requested", scene_name)


func mapod_pop_scene_request():
	emit_signal("pop_scene_requested")


func mapod_3d_start_position():
	return [Vector3(0, 0, 0), Vector3(0, 0, 0)]


func mapod_2d_start_position():
	return Vector2(0, 0)


func mapod_object_action_requested(_object_uid: int, _action: String, _params):
	pass


func mapod_object_first_interaction(object_uid: int):
	if object_uid > 0:
		object_uid -= 1
	if object_uid < len(_mapod_objects):
		var object = _mapod_objects[object_uid]
		if object != null:
			object.do_first_interaction()


func mapod_object_second_interaction(object_uid: int):
	if object_uid > 0:
		object_uid -= 1
	if object_uid < len(_mapod_objects):
		var object = _mapod_objects[object_uid]
		if object != null:
			object.do_second_interaction()

# ----- private methods

func _on_object_action_requested(object_uid: int, action: String, params):
	mapod_object_action_requested(object_uid, action, params)

