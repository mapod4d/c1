# tool

# class_name
class_name Quiet2DState

# extends
extends BaseMapod2DState

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

# ----- public methods

func enter():
	.enter()
	_mapod_print_debug_msg("State2DQuiet enter", 1)
	# reset speed
	_mapod_stop()


func exit():
	.exit()
	_mapod_print_debug_msg("State2DQuiet exit", 1)
	pass


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

	if _is_in_quiet() == false:
		_change_state("move")

# ----- private methods
