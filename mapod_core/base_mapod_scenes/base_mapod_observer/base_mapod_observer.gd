# tool

# class_name
class_name BaseMapodObserver

# extends
extends BaseMapodPlayer2D

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
# speed parameters
export(float) var speed_max = 4000
export(float) var speed_multiplier = 150
export(float) var inertia = 5
export(float) var acceleration = 0.25
# mouse parameters
export(float) var mouse_sensitivity = 450
export(float) var game_pad_sensitivity = 150

# ----- public variables

# ----- private variables

# ----- onready variables
onready var hud = $Hud/Hudnl
onready var choices = $ChoicesLayer/Choices
onready var ray_cast = $RayCast2D
onready var mapod_2d_state_machine = $Mapod2DStateMachine


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_debug_flag(defer_debug_flag)
	if choices:
		choices.connect("scene_metaverse_requested", self, "_on_scene_metaverse_requested")
	if mapod_2d_state_machine:
		# update static data
		mapod_2d_state_machine.static_states_data["hud"] = hud
		mapod_2d_state_machine.static_states_data["speed_max"] = speed_max
		mapod_2d_state_machine.static_states_data["speed_multiplier"] = speed_multiplier
		mapod_2d_state_machine.static_states_data["inertia"] = inertia
		mapod_2d_state_machine.static_states_data["mouse_sensitivity"] = mouse_sensitivity
		mapod_2d_state_machine.static_states_data["game_pad_sensitivity"] = game_pad_sensitivity
		# handle states
		for state_name in mapod_2d_state_machine.states_map:
			var child = mapod_2d_state_machine.states_map[state_name]
			if child is BaseMapod2DState:
				print(child)
				var cRet = child.connect("print_debug_msg_requested", self, "_on_print_debug_msg_requested")
				assert(cRet == 0)
				cRet = child.connect("move_requested", self, "_on_move_requested")
				assert(cRet == 0)
				cRet = child.connect("scene_requested", self, "_on_scene_requested")
				assert(cRet == 0)
				cRet = child.connect("push_scene_requested", self, "_on_push_scene_requested")
				assert(cRet == 0)
				cRet = child.connect("pop_scene_requested", self, "_on_pop_scene_requested")
				assert(cRet == 0)
				cRet = child.connect("choices_open_requested", self, "_on_choices_open_requested")
				assert(cRet == 0)
				cRet = child.connect("choices_close_requested", self, "_on_choices_close_requested")
				assert(cRet == 0)
		mapod_2d_state_machine.set_active(true)

# ----- remaining built-in virtual methods

func _process(_delta):
	# update static data
	if mapod_2d_state_machine:
		mapod_2d_state_machine.static_states_data["speed_max"] = speed_max
		mapod_2d_state_machine.static_states_data["speed_multiplier"] = speed_multiplier
		mapod_2d_state_machine.static_states_data["inertia"] = inertia
		mapod_2d_state_machine.static_states_data["accelration"] = acceleration
		mapod_2d_state_machine.static_states_data["mouse_sensitivity"] = mouse_sensitivity
		mapod_2d_state_machine.static_states_data["game_pad_sensitivity"] = game_pad_sensitivity

#		if ray_cast:
#			if ray_cast.is_colliding():
#				var collider_object = ray_cast.get_collider()
#				print("colliding %s" % collider_object.get_class())

	# hud and collision
	if hud:
		hud.print_debug_msg("speed {s}".format({ "s": speed_to_string()}), 0)
		hud.print_debug_msg("", 2)
		_not_analysable()
		if ray_cast:
			if ray_cast.is_colliding():
				var collider_object = ray_cast.get_collider()
				# trovato un oggetto analizzabile
				if collider_object is MapodStaticBodyAnalyzable2D:
					var information = collider_object.information()
					var e_information = collider_object.e_information()
					hud.print_debug_msg("colliding %s" % information, 2)
					hud.set_info_data(information)
					var data_analysed = collider_object.open()
					if data_analysed["can_be_opened"]:
						mapod_2d_state_machine.static_states_data["can_be_opened"] = true
						mapod_2d_state_machine.static_states_data["scene_request_type"] = data_analysed["scene_request_type"]
						mapod_2d_state_machine.static_states_data["request_scene"] = data_analysed["request_scene"]
						hud.set_e_info_data(e_information)
						hud.set_show_analysable(true, false)
				else:
					hud.print_debug_msg("colliding %s" % collider_object.get_class(), 2)

# ----- public methods

func calc_position(req_position: Vector2, video_size: Vector2):
	var retVal = Vector2(0, 0)
	retVal.x = req_position.x + (video_size.x / 2)
	retVal.y = req_position.y + (video_size.y / 2)
	return retVal

# ----- private methods

func _not_analysable():
	mapod_2d_state_machine.static_states_data["can_be_opened"] = false
	if hud:
		hud.set_info_data("")
		hud.set_show_analysable(false, false)


# aggiorna un messaggio di debug
func _on_print_debug_msg_requested(msg: String, index: int):
	if hud:
		hud.print_debug_msg(msg, index)


func _on_move_requested(speed: Vector2, delta: float):
	var new_position = Vector2(0, 0)
	new_position.x = lerp(position.x, position.x + speed.x * delta, acceleration)
	new_position.y = lerp(position.y, position.y + speed.y * delta, acceleration)
	new_position.x = clamp(new_position.x, 0, _width_size)
	new_position.y = clamp(new_position.y, 0, _height_size)
	position = new_position


func _on_scene_metaverse_requested():
	_metaverse_request()


func _on_scene_requested(scene_name):
	_scene_request(scene_name)


func _on_push_scene_requested(scene_name):
	_push_scene_request(scene_name)


func _on_pop_scene_requested():
	_pop_scene_request()


func _on_choices_open_requested():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	choices.visible = true


func _on_choices_close_requested():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	choices.visible = false
