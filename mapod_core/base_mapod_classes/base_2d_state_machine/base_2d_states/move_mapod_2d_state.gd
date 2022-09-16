class_name MoveMapod2DState
extends BaseMapod2DState


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- public methods

#func speed_is_zero():
#	pass


#func is_speed_zero() -> bool:
#	var retVal = false
#	var speed = abs(owner.speed.x) + abs(owner.speed.z) + abs(owner.speed.y)
#	if  speed == 0:
#		retVal = true
#	return retVal

# ----- private methods

func _in_quiet():
	pass


func _move(delta):
	# move only if is not freezed
	_freeze_static_states_data()
	if local_static_states_data["freezed"] == false:
		# handle movement request
		var speed = _decrease_speed(delta)
		var flagQuiet = _is_in_quiet()
		speed += input_movement_vector * local_static_states_data["speed_multiplier"]
		input_vector_handled()
		var speed_max = local_static_states_data["speed_max"]
		speed.x = clamp(speed.x, -speed_max, speed_max)
		speed.y = clamp(speed.y, -speed_max, speed_max)
		# update speed
		local_static_states_data["speed"] = speed
		# update static data
		_static_states_data_update(local_static_states_data)
		# send to player movement and speed
		_mapod_move(speed, delta)
		if flagQuiet:
			_in_quiet()


# decrementa la velocita'  tenendo conto che non venga richiesta una cosa differente
# vedere linear_interpolate
func _decrease_speed(delta):
	_freeze_static_states_data()
	var inertia = local_static_states_data["inertia"]
	var current_speed = static_states_data["speed"]
	var speed = Vector2(0, 0)

	if input_movement_vector.x != 0:
		speed.x = current_speed.x
	else:
		current_speed.x = clamp(current_speed.x, -20, 20)

	if input_movement_vector.y != 0:
		speed.y = current_speed.y
	else:
		current_speed.y = clamp(current_speed.y, -20, 20)

	if speed != current_speed:
		current_speed = current_speed.linear_interpolate(speed, inertia * delta)
		if current_speed.x < 1 and current_speed.x > -1:
			current_speed.x = 0
		if current_speed.y < 1 and current_speed.y > -1:
			current_speed.y = 0
	
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
