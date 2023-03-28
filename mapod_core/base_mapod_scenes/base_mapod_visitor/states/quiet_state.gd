class_name QuietState
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
	_mapod_print_debug_msg("StateQuiet enter", 1)
	# reset speed
	_mapod_stop()


func exit():
	.exit()
	_mapod_print_debug_msg("StateQuiet exit", 1)
	pass

func update(delta):
	.update(delta)
	if not _is_in_quiet():
		_change_state("move")

func handle_input(event):
	.handle_input(event)
	
	if _is_zoom_requested():
		_mapod_zoom()

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

	if _first_interaction_active():
		input_first_interaction_handled()
		_mapod_freeze()
		_change_state("first_interaction")

	if _second_interaction_active():
		input_second_interaction_handled()
		_mapod_freeze()
		_change_state("second_interaction")
