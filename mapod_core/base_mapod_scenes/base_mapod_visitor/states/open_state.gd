class_name OpenState
extends BaseMapodState


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables

# ----- public methods

func enter():
	.enter()
	_mapod_print_debug_msg("OpenState enter", 1)


func exit():
	.exit()
	_mapod_print_debug_msg("OpenState exit", 1)


func update(delta):
	_freeze_static_states_data()
	var scene_name = local_static_states_data["request_scene"]
	if local_static_states_data["scene_request_type"] == MapodGlobal.MAPODSCENEREQUESTTYPE.PUSHRQS:
		_mapod_push_scene_request(scene_name)
	elif local_static_states_data["scene_request_type"] == MapodGlobal.MAPODSCENEREQUESTTYPE.POPRQS:
		_mapod_pop_scene_request()
	elif local_static_states_data["scene_request_type"] == MapodGlobal.MAPODSCENEREQUESTTYPE.STANDARDRQS:
		_mapod_scene_request(scene_name)


# exit from open state
func handle_input(event):
	.handle_input(event)

	var scene_name = local_static_states_data["request_scene"]

	if local_static_states_data["scene_request_type"] == MapodGlobal.MAPODSCENEREQUESTTYPE.STANDARDRQS:
		if (scene_name == null) or (scene_name == ''):
			if _open_active():
				input_open_handled()
				_mapod_unfreeze()
				_change_state("quiet")

	if local_static_states_data["scene_request_type"] == MapodGlobal.MAPODSCENEREQUESTTYPE.PUSHRQS:
		if (scene_name == null) or (scene_name == ''):
			if _open_active():
				input_open_handled()
				_mapod_unfreeze()
				_change_state("quiet")
