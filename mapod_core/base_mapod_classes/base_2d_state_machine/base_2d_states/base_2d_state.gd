class_name Base2DState
extends Node


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
# static data simulation
var static_states_data setget _set_static_states_data
# static data simulation read only flag
var _static_states_data_ronly = false
# local static data simulation (writable)
var local_static_states_data = {}

# ----- private variables

# ----- onready variables


# ----- public methods

# oneshot write static data
func allow_write_on_static_states_data():
	_static_states_data_ronly = true


# Initialize the state. E.g. change the animation.
func enter():
	pass


# Clean up the state. Reinitialize values like a timer.
func exit():
	pass


func handle_input(_event):
	pass


func update(_delta):
	pass


# ----- private methods

# protect static data
func _set_static_states_data(data):
	if _static_states_data_ronly:
		static_states_data = data.duplicate(true)
		_static_states_data_ronly = false

# freeze static data
func _freeze_static_states_data():
	local_static_states_data = static_states_data.duplicate(true)

