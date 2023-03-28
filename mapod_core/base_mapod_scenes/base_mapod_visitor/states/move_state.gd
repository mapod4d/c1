class_name MoveState
extends MoveMapodState


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
	_mapod_print_debug_msg("MoveState enter", 1)


func exit():
	.exit()
	_mapod_print_debug_msg("MoveState exit", 1)


func update(delta):
	.update(delta)
	_move(delta)
	_updateState()


func updateEveryEveryFrame(delta):
	.updateEveryEveryFrame(delta)
	_rotate(delta)


func handle_input(event):
	.handle_input(event)

	if _choices_active():
		input_choices_handled()
		_mapod_freeze()
		_change_state("choices")

	if _open_active():
		input_open_handled()
		_mapod_freeze()
		_change_state("open")
	
	if _function_f1_active():
		input_function_f1_handled()
		_mapod_function_f1_request()


# nessuna richiesta di movimento
func _in_quiet():
	if _is_speed_zero():
		_change_state("quiet")

