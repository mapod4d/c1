class_name BaseMapod2DState
extends Base2DState


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
signal move_requested(speed, delta)
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

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
# input buffers
var input_movement_vector = Vector2(0, 0)
var input_open = false
var input_choices = false
var disable_esc = false

# ----- private variables

# ----- onready variables


# ----- public methods

# normalizzazione input per il movimento
func handle_input(event):
	.handle_input(event)
	
	_freeze_static_states_data()
	# mouse visible
	if event.is_action_pressed("mapod_esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if local_static_states_data["hud"]:
			local_static_states_data["hud"].enable_input(true)

	# fullscreen/ window
	if event.is_action_pressed("mapod_full_win"):
		OS.set_window_fullscreen(!OS.window_fullscreen)

	# capture mouse when visible if hud is hidden
	if event is InputEventMouseButton:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# open object analysable
	input_open = false
	if event.is_action_pressed("mapod_open"):
		input_open = true

	# choices
	input_choices = false
	if event.is_action_pressed("mapod_choices"):
		input_choices = true
	
	# mouse motion
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			input_movement_vector.x = event.relative.x * owner.mouse_sensitivity
			input_movement_vector.y = event.relative.y * owner.mouse_sensitivity

	# key or joypad movement
	var movement = event.is_action_pressed("mapod_move_right")
	movement = movement or event.is_action_pressed("mapod_move_left")
	movement = movement or event.is_action_pressed("mapod_move_forward")
	movement = movement or event.is_action_pressed("mapod_move_backward")
	if movement:
		input_movement_vector = Vector2(
			Input.get_action_strength("mapod_move_right") - Input.get_action_strength("mapod_move_left"),
			Input.get_action_strength("mapod_move_backward") - Input.get_action_strength("mapod_move_forward")
		)
		input_movement_vector = input_movement_vector.normalized()


func update(delta):
	.update(delta)
	if "can_be_opened" in static_states_data:
		if static_states_data["can_be_opened"] == false:
			input_open = false
	else:
		input_open = false
	var msg = "input ({x}, {y})".format({
		"x": input_movement_vector.x,
		"y": input_movement_vector.y,
	})
	_mapod_print_debug_msg(msg, 3)


func input_vector_handled():
	input_movement_vector = Vector2(0, 0)


func input_open_handled():
	input_open = false


func input_choices_handled():
	input_choices = false

# ----- private methods

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
	var retVal = true
	_freeze_static_states_data()
	if local_static_states_data["speed"].length() > 0:
		retVal = false
	return retVal


# there is a movement request
func _is_movement_requested() -> bool:
	# vedere get_action_strength
	var retVal = false
	if input_movement_vector.length() > 0:
		retVal = true
	return retVal


# there is a movement or rotation request
func _is_in_quiet() -> bool:
	var retVal = true
	if _is_movement_requested():
		retVal = false
	return retVal


# change state
func _change_state(next_state_name):
	emit_signal("change_state_requested", next_state_name)


# update static data
func _static_states_data_update(data):
	emit_signal("static_states_data_update_requested", data)


# porint debug msg
func _mapod_print_debug_msg(msg, index):
	emit_signal("print_debug_msg_requested", msg, index)


# set speed  request to 0
func _mapod_stop():
	input_movement_vector = Vector2(0, 0)
	_freeze_static_states_data()
	local_static_states_data["speed"] = Vector2(0, 0)
	_static_states_data_update(local_static_states_data)


# set speed request to 0 LOCK
func _mapod_freeze():
	input_movement_vector = Vector2(0, 0)
	_freeze_static_states_data()
	local_static_states_data["speed"] = Vector2(0, 0)
	local_static_states_data["freezed"] = true
	_static_states_data_update(local_static_states_data)


# set speed request to 0 UNLOCK
func _mapod_unfreeze():
	input_movement_vector = Vector2(0, 0)
	_freeze_static_states_data()
	local_static_states_data["speed"] = Vector2(0, 0)
	local_static_states_data["freezed"] = false
	_static_states_data_update(local_static_states_data)


func _mapod_disable_esc():
	disable_esc = true


func _mapod_enable_esc():
	disable_esc = false


# move and update speed
func _mapod_move(speed: Vector2, delta: float):
	emit_signal("move_requested", speed, delta)


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
