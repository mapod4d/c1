class_name MapodStateMachine
extends BaseStateMachine


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables
onready var quiet_state = $QuietState
onready var move_state =  $MoveState
onready var open_state = $OpenState
onready var choices_state = $ChoicesState
onready var first_interaction_state = $FirstInteractionState
onready var second_interaction_state = $SecondInteractionState


# ----- built-in virtual _ready method

func _ready():
	states_map = {
		"quiet": quiet_state,
		"move": move_state,
		"open": open_state,
		"choices": choices_state,
		"first_interaction": first_interaction_state,
		"second_interaction": second_interaction_state,
	}

