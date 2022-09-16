# tool

# class_name
class_name Mapod2DStateMachine

# extends
extends Base2DStateMachine

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables
onready var quiet_state = $Quiet2DState
onready var move_state =  $Move2DState
onready var open_state = $Open2DState
onready var choices_state = $Choices2DState


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	states_map = {
		"quiet": quiet_state,
		"move": move_state,
		"open": open_state,
		"choices": choices_state,
	}

# ----- remaining built-in virtual methods

# ----- public methods

# ----- private methods
