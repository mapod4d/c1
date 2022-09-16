# tool

# class_name
class_name Move2DState

# extends
extends MoveMapod2DState

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
	_mapod_print_debug_msg("Move2DState enter", 1)


func exit():
	.exit()
	_mapod_print_debug_msg("Move2DState exit", 1)


func update(delta):
	.update(delta)
	_move(delta)


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


# nessuna richiesta di movimento
func _in_quiet():
	if _is_speed_zero():
		_change_state("quiet")

# ----- private methods
