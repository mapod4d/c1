class_name BaseMapodState
extends BaseState


# ----- signals
# -- connected to state machine
# cambio dello stato
signal change_state_requested(next_state_name)
# update static data
signal static_states_data_update_requested(data)
# -- connected to visitor
# stampa debug
signal print_debug_msg_requested(msg, index)
# move and slide
signal move_requested(delta_speed, speed)
# rotate realative
signal rotate_requested(relative)
# change scene
signal scene_requested(scene)
# change scene with push
signal push_scene_requested(scene)
# change scene with pop
signal pop_scene_requested()
# open choices
signal choices_open_requested()
# close choices
signal choices_close_requested()
# object first interaction object
signal object_first_interaction_requested(object_uid)
# object second interaction object
signal object_second_interaction_requested(object_uid)
# zoom
signal zoom_requested()
# unzoom
signal unzoom_requested()


# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
# input buffers
var input_movement_vector = Vector3(0, 0, 0)
var input_rotation_vector = Vector2(0, 0)
var input_zoom = 0
var input_open = false
var input_choices = false
var input_first_interaction = false
var input_second_interaction = false
var disable_esc = false
#var joy_pad_motion_vector = Vector2(0, 0)
#var joy_pad_motion_tollerance = 0.2

# ----- private variables

# ----- onready variables


# ----- public methods

# normalizzazione input per il movimento
func handle_input(event):
	.handle_input(event)
	_freeze_static_states_data()
	var mouse_sensitivity = local_static_states_data["mouse_sensitivity"]

	# mouse visible
	if event.is_action_pressed("mapod_esc"):
		if disable_esc == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if local_static_states_data["hud"]:
				local_static_states_data["hud"].enable_input(true)
	
	# fullscreen/ window
	if event.is_action_pressed("mapod_full_win"):
		OS.set_window_fullscreen(!OS.window_fullscreen)

	## zoom and capture
	if event is InputEventMouseButton:
		# capture mouse when visible if hud is hidden
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			print("Wheel up")
			input_zoom = 1
		elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			print("Wheel down")
			input_zoom = -1
	if event.is_action_pressed("mapod_zoom_in"):
		input_zoom = 1
	elif event.is_action_pressed("mapod_zoom_out"):
		input_zoom = -1
	
	# open object analysable
	input_open = false
	if event.is_action_pressed("mapod_open"):
		input_open = true

	# object interactions
	input_first_interaction = false
	input_second_interaction = false
	if event.is_action_pressed("mapod_first_interaction"):
		input_first_interaction = true
	elif event.is_action_pressed("mapod_second_interaction"):
		input_second_interaction = true
	
	# choices
	input_choices = false
	if event.is_action_pressed("mapod_choices"):
		input_choices = true
	
	# mouse motion
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			input_rotation_vector.x = event.relative.x * mouse_sensitivity
			input_rotation_vector.y = event.relative.y * mouse_sensitivity
	
	# gamepad and arrows key rotation
	if event.is_action_pressed("mapod_look_right"):
		input_rotation_vector.x = local_static_states_data["game_pad_sensitivity"]
	if event.is_action_pressed("mapod_look_left"):
		input_rotation_vector.x = -local_static_states_data["game_pad_sensitivity"]
	if event.is_action_pressed("mapod_look_up"):
		input_rotation_vector.y = -local_static_states_data["game_pad_sensitivity"]
	if event.is_action_pressed("mapod_look_down"):
		input_rotation_vector.y = local_static_states_data["game_pad_sensitivity"]

	# key or joypad movement
	var movement = event.is_action_pressed("mapod_move_right")
	movement = movement or event.is_action_pressed("mapod_move_left")
	movement = movement or event.is_action_pressed("mapod_move_up")
	movement = movement or event.is_action_pressed("mapod_move_down")
	movement = movement or event.is_action_pressed("mapod_move_forward")
	movement = movement or event.is_action_pressed("mapod_move_backward")
	if movement:
		input_movement_vector = Vector3(
			# Input.get_action_strength("mapod_move_right") - Input.get_action_strength("mapod_move_left"),
			Input.get_axis("mapod_move_left", "mapod_move_right"),
			#Input.get_action_strength("mapod_move_up") - Input.get_action_strength("mapod_move_down"),
			Input.get_axis("mapod_move_down", "mapod_move_up"),
			#Input.get_action_strength("mapod_move_forward") - Input.get_action_strength("mapod_move_backward")
			Input.get_axis("mapod_move_backward", "mapod_move_forward")
		)
		input_movement_vector = input_movement_vector.normalized()



func update(delta):
	.update(delta)
	if "can_be_opened" in static_states_data:
		if static_states_data["can_be_opened"] == false:
			input_open = false
	else:
		input_open = false
	var msg = "inputv ({x}, {y}, {z}) rotate ({xr}, {yr})".format({
		"x": input_movement_vector.x,
		"y": input_movement_vector.y,
		"z": input_movement_vector.z,
		"xr": input_rotation_vector.x,
		"yr": input_rotation_vector.y,
	})
	_mapod_print_debug_msg(msg, 3)


func updateEveryEveryFrame(delta):
	.updateEveryEveryFrame(delta)


func input_vector_handled():
	input_movement_vector = Vector3(0, 0, 0)


func input_rotate_vector_handled():
	input_rotation_vector = Vector2(0, 0)


func input_zoom_handled():
	input_zoom = 0


func input_open_handled():
	input_open = false


func input_choices_handled():
	input_choices = false


func input_first_interaction_handled():
	input_first_interaction = false


func input_second_interaction_handled():
	input_second_interaction = false

# ----- private methods

# check first_interaction request
func _first_interaction_active():
	var retVal = false
	_freeze_static_states_data()
	if input_choices == false:
		if 'first_interaction' in local_static_states_data:
			if local_static_states_data['first_interaction'] == true:
				if input_first_interaction == true:
					retVal = true
	return retVal

# check second_interaction request
func _second_interaction_active():
	var retVal = false
	_freeze_static_states_data()
	if input_choices == false:
		if 'second_interaction' in local_static_states_data:
			if local_static_states_data['second_interaction'] == true:
				if input_second_interaction == true:
					retVal = true
	return retVal

# check open request
func _open_active():
	var retVal = false
	_freeze_static_states_data()
	if local_static_states_data["can_be_opened"]:
		if input_choices == false:
			if input_open == true:
				retVal = true
	return retVal


# check choices request
func _choices_active():
	var retVal = false
	if input_choices == true:
		retVal = true
	return retVal


# there is a movement request
func _is_speed_zero() -> bool:
	var retVal = false
	_freeze_static_states_data()
	if local_static_states_data["speed"].length() == 0:
		retVal = true
	return retVal


# there is a movement request
func _is_movement_requested() -> bool:
	# vedere get_action_strength
	var retVal = true
	if input_movement_vector.length() == 0:
		retVal = false
	return retVal

# there is a zoom request
func _is_zoom_requested() -> bool:
	var retVal = false
	if input_zoom != 0:
		retVal = true
	return retVal

# there is a rotation request
func _is_rotation_requested() -> bool:
	# vedere get_action_strength
	var retVal = true
	if input_rotation_vector.length() == 0:
		retVal = false
	return retVal


# there is a movement or rotation request
func _is_in_quiet() -> bool:
	var retVal = false
	if not _is_movement_requested():
		if not _is_rotation_requested():
			if _is_speed_zero():
				retVal = true
	return retVal


# change state
func _change_state(next_state_name):
	deactivate()
	emit_signal("change_state_requested", next_state_name)


# update static data
func _static_states_data_update(data):
	emit_signal("static_states_data_update_requested", data)


# porint debug msg
func _mapod_print_debug_msg(msg, index):
	emit_signal("print_debug_msg_requested", msg, index)


# set speed  request to 0
func _mapod_stop():
	input_movement_vector = Vector3(0, 0, 0)
	input_rotation_vector = Vector2(0, 0)
	_freeze_static_states_data()
	local_static_states_data["speed"] = Vector3(0, 0, 0)
	_static_states_data_update(local_static_states_data)


# set speed and rotation request to 0 LOCK
func _mapod_freeze():
	input_movement_vector = Vector3(0, 0, 0)
	input_rotation_vector = Vector2(0, 0)
	_freeze_static_states_data()
	local_static_states_data["speed"] = Vector3(0, 0, 0)
	local_static_states_data["freezed"] = true
	_static_states_data_update(local_static_states_data)


# set speed and rotation request to 0 UNLOCK
func _mapod_unfreeze():
	input_movement_vector = Vector3(0, 0, 0)
	input_rotation_vector = Vector2(0, 0)
	_freeze_static_states_data()
	local_static_states_data["speed"] = Vector3(0, 0, 0)
	local_static_states_data["freezed"] = false
	_static_states_data_update(local_static_states_data)


func _mapod_disable_esc():
	disable_esc = true


func _mapod_enable_esc():
	disable_esc = false


# move and update speed
func _mapod_move(delta_speed, speed):
	emit_signal("move_requested", delta_speed, speed)


# rotate
func _mapod_rotate(relative):
	emit_signal("rotate_requested", relative)


# change scene
#  exit from this level
#  reset all info
func _mapod_scene_request(scene):
	emit_signal("scene_requested", scene)


# change scene with push
#  exit from this level
#  save currrent info
#  reset all info
func _mapod_push_scene_request(scene):
	emit_signal("push_scene_requested", scene)


# change scene with pop
#  exit from this level
#  restore last pushed info
func _mapod_pop_scene_request():
	emit_signal("pop_scene_requested")


# map open
func _mapod_choices_open_request():
	_mapod_disable_esc()
	emit_signal("choices_open_requested")


# map close
func _mapod_choices_close_request():
	_mapod_enable_esc()
	emit_signal("choices_close_requested")


# first interaction from object
func _mapod_object_first_interaction_request(object_uid: int):
	emit_signal("object_first_interaction_requested", object_uid)


# second interaction from object
func _mapod_object_second_interaction_request(object_uid: int):
	emit_signal("object_second_interaction_requested", object_uid)


# zoom or unzoom request
func _mapod_zoom():
	if input_zoom > 0:
		input_zoom_handled()
		emit_signal("zoom_requested")
	elif input_zoom < 0:
		input_zoom_handled()
		emit_signal("unzoom_requested")

