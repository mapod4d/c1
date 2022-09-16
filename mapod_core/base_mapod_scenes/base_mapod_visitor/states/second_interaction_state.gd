# tool

# class_name
class_name SecondInteractionState

# extends
extends BaseMapodState

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
	_mapod_print_debug_msg("SecondInteractionState enter", 1)


func exit():
	.exit()
	_mapod_print_debug_msg("SecondInteractState exit", 1)


func handle_input(event):
	.handle_input(event)
	
	_freeze_static_states_data()
	_mapod_object_second_interaction_request(local_static_states_data["object_unique_id"])
	_mapod_unfreeze()
	_change_state("quiet")

# ----- private methods
