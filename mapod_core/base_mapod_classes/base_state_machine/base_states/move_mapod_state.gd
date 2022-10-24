class_name MoveMapodState
extends BaseMapodState


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables
var _input_rotation_vector: Vector2

# ----- onready variables


# ----- public methods

# ----- private methods

func _in_quiet():
	pass


func _move(delta):
	# move only if is not freezed
	_freeze_static_states_data()
	if local_static_states_data["freezed"] == false:
		# handle movement request
		var speed = _decrease_speed(delta)
		speed += input_movement_vector
		input_vector_handled()
		var speed_max = local_static_states_data["speed_max"]
		speed.x = clamp(speed.x, -speed_max, speed_max)
		speed.y = clamp(speed.y, -speed_max, speed_max)
		speed.z = clamp(speed.z, -speed_max, speed_max)
		# move
		var delta_speed = Vector3(0, 0, 0)
		var speed_multiplier = local_static_states_data["speed_multiplier"]
		delta_speed.x = speed.x * speed_multiplier * delta
		delta_speed.y = speed.y * speed_multiplier * delta
		delta_speed.z = speed.z * speed_multiplier * delta
		# update speed
		local_static_states_data["speed"] = speed
		# update static data
		_static_states_data_update(local_static_states_data)
		# send to player movement and speed
		_mapod_move(delta_speed, speed)


func _rotate(delta):
	# rotatr only if is not freezed
	_freeze_static_states_data()
	if local_static_states_data["freezed"] == false:
		var smooth = local_static_states_data["mouse_smooth"]
		_input_rotation_vector = input_rotation_vector
		input_rotate_vector_handled()
		_input_rotation_vector = _input_rotation_vector.linear_interpolate(
			Vector2(0, 0), delta * smooth
		)
		_mapod_rotate(_input_rotation_vector)


func _updateState():
	if _is_in_quiet():
		_in_quiet()


# decrementa la velocita'  tenendo conto che non venga richiesta una cosa differente
# vedere linear_interpolate
func _decrease_speed(delta):
	_freeze_static_states_data()
	var inertia = local_static_states_data["inertia"]
	var current_speed = static_states_data["speed"]
	var speed = Vector3(0, 0, 0)

	if input_movement_vector.x != 0:
		speed.x = current_speed.x
	else:
		current_speed.x = clamp(current_speed.x, -20, 20)

	if input_movement_vector.y != 0:
		speed.y = current_speed.y
	else:
		current_speed.y = clamp(current_speed.y, -20, 20)

	if input_movement_vector.z != 0:
		speed.z = current_speed.z
	else:
		current_speed.z = clamp(current_speed.z, -20, 20)

	if speed != current_speed:
		current_speed = current_speed.linear_interpolate(speed, inertia * delta)
		if current_speed.x < 1 and current_speed.x > -1:
			current_speed.x = 0
		if current_speed.y < 1 and current_speed.y > -1:
			current_speed.y = 0
		if current_speed.z < 1 and current_speed.z > -1:
			current_speed.z = 0
	
	return current_speed


func _decrease_speed_inertial(speed):
	_freeze_static_states_data()
	var inertia = local_static_states_data["inertia"]
	if speed > 0:
		speed -= inertia
		if speed < inertia:
			speed = 0
	elif speed < 0:
		speed += inertia
		if speed > inertia:
			speed = 0
	return speed
