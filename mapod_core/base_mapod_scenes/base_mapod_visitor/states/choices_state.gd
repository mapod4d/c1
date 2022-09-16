class_name ChoicesState
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
	_mapod_print_debug_msg("ChoicesState enter", 1)
	# stop and lock
	_mapod_freeze()
	_mapod_choices_open_request()

func exit():
	.exit()
	_mapod_print_debug_msg("ChoicesState exit", 1)


func update(delta):
	pass


# exit from open state
func handle_input(event):
	.handle_input(event)

	if _choices_active():
		input_choices_handled()
		_mapod_choices_close_request()
		_mapod_unfreeze()
		_change_state("quiet")
