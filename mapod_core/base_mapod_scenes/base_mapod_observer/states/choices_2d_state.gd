# tool

# class_name
class_name Choices2DState

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
	_mapod_print_debug_msg("Choices2DState enter", 1)
	# stop and lock
	_mapod_freeze()
	_mapod_choices_open_request()


func exit():
	.exit()
	_mapod_print_debug_msg("Choices2DState exit", 1)


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

# ----- private methods
