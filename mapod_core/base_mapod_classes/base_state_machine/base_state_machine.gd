class_name BaseStateMachine
extends Node


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
# stato iniziale
export(NodePath) var start_state

# ----- public variables
# dati comuni a tutti gli stati
var static_states_data = {
	"speed": Vector3(0, 0, 0),
	"zoom": 0,
	"freezed": false,
	"can_be_opened": false,
}
# stato corrente
var current_state = null
# mappa degli stati
var states_map = {}

# ----- private variables
# flag di attivazione
var _active = false setget set_active

# ----- onready variables


# ----- built-in virtual _ready method
func _ready():
	if not start_state:
		start_state = get_child(0).get_path()
	for child in get_children():
		var err = child.connect("change_state_requested", self, "_on_change_state_requested")
		if err:
			print("ERROR changeState")
			printerr(err)
		err = child.connect("static_states_data_update_requested", self, "_on_static_states_data_update_requested")
		if err:
			print("ERROR static_states_data_update_requested")
			printerr(err)

	# attivazione e inizializzazione della state machine
	#set_active(true)
	initialize(start_state)


# ----- public methods

func set_active(value):
	_active = value
	if _active:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_physics_process(value)
	set_process_input(value)


func initialize(initial_state):
	current_state = get_node(initial_state)
	_update_static_data()
	current_state.enter()
	current_state.activate()


func getStaticStatesData():
	return static_states_data


# ----- private methods

func _update_static_data():
	current_state.allow_write_on_static_states_data()
	current_state.static_states_data = static_states_data


func _unhandled_input(event):
	_update_static_data()
	current_state.handle_input(event)


func _physics_process(delta):
	# joypad echo event
	for action in [
		"mapod_move_forward",
		"mapod_move_backward",
		"mapod_move_left",
		"mapod_move_right",
		"mapod_move_up",
		"mapod_move_down",
		"mapod_look_right",
		"mapod_look_left",
		"mapod_look_up",
		"mapod_look_down",
		"mapod_zoom_in",
		"mapod_zoom_out"
	]:
		if Input.is_action_pressed(action):
			var event = InputEventAction.new()
			event.action = action
			event.pressed = true
			event.strength = 1
			Input.parse_input_event(event)
	if current_state.is_active():
		_update_static_data()
		current_state.update(delta)


func _process(delta):
	if current_state.is_active():
		current_state.updateEveryEveryFrame(delta)


# aggiorna un messaggio di debug
func _on_print_debug_msg_requested(msg:String, index:int):
		emit_signal("print_debug_msg_requested", msg, index)


func _on_change_state_requested(state_name):
	if _active:
		if state_name in states_map:
			# print("_change_state {str}".format({"str": state_name}))
			current_state.exit()
			current_state = states_map[state_name]
			# init dati statici
			_update_static_data()
			current_state.enter()
			current_state.activate()


func _on_static_states_data_update_requested(data):
	static_states_data = data.duplicate(true)
	_update_static_data()
