# tool

# class_name
class_name BaseMapodVisitor

# extends
extends BaseMapodPlayer

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
# speed parameters
export(bool) var choices_extended = false
export(float) var speed_max = 150
export(float) var speed_multiplier = 3
export(float) var inertia = 5
# mouse parameters
#export(float) var mouse_sensitivity = 40
export(float) var mouse_sensitivity = 0.4
export(float) var mouse_smooth = 0.0001
export(float) var game_pad_sensitivity = 2
export(float) var zoom_smooth = 1
export(float) var min_fov = 40
export(float) var max_fov = 70

# ----- public variables

# ----- private variables

# ----- onready variables
onready var camera = $RotationHelper/Camera
onready var rotation_helper = $RotationHelper
onready var hud = $Hud/Hudnl
onready var choices = $ChoicesLayer/Choices
onready var ray_cast = $RotationHelper/Camera/RayCast
onready var mapod_state_machine = $MapodStateMachine


# ----- built-in virtual _ready method

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_debug_flag(defer_debug_flag)
	camera.fov = max_fov
	if choices:
		if choices_extended == true:
			choices.force_extended()
		choices.connect("scene_metaverse_requested", self, "_on_scene_metaverse_requested")
	if mapod_state_machine:
		# update static data
		mapod_state_machine.static_states_data["hud"] = hud
		mapod_state_machine.static_states_data["speed_max"] = speed_max
		mapod_state_machine.static_states_data["speed_multiplier"] = speed_multiplier
		mapod_state_machine.static_states_data["inertia"] = inertia
		mapod_state_machine.static_states_data["mouse_sensitivity"] = mouse_sensitivity
		mapod_state_machine.static_states_data["mouse_smooth"] = mouse_smooth
		mapod_state_machine.static_states_data["game_pad_sensitivity"] = game_pad_sensitivity
		mapod_state_machine.static_states_data["zoom_smooth"] = zoom_smooth
		mapod_state_machine.static_states_data["min_fov"] = min_fov
		mapod_state_machine.static_states_data["max_fov"] = max_fov
		mapod_state_machine.static_states_data["zoom"] = 1 / (camera.fov / max_fov)
		# handle states
		for state_name in mapod_state_machine.states_map:
			var child = mapod_state_machine.states_map[state_name]
			if child is BaseMapodState:
				print(child)
				var cRet = child.connect("print_debug_msg_requested", self, "_on_print_debug_msg_requested")
				assert(cRet == 0)
				cRet = child.connect("move_requested", self, "_on_move_requested")
				assert(cRet == 0)
				cRet = child.connect("rotate_requested", self, "_on_rotate_requested")
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
				cRet = child.connect("object_first_interaction_requested", self, "_on_object_first_interaction_requested")
				assert(cRet == 0)
				cRet = child.connect("object_second_interaction_requested", self, "_on_object_second_interaction_requested")
				assert(cRet == 0)
				cRet = child.connect("zoom_requested", self, "_on_zoom_requested")
				assert(cRet == 0)
				cRet = child.connect("unzoom_requested", self, "_on_unzoom_requested")
				assert(cRet == 0)
		mapod_state_machine.set_active(true)
	choices.connect("set_panorama_requested", self, "_on_set_panorama_requested")


# ----- remaining built-in virtual methods

func _process(_delta):
	var speed = 0

	# update static data
	if mapod_state_machine:
		mapod_state_machine.static_states_data["speed_max"] = speed_max
		mapod_state_machine.static_states_data["speed_multiplier"] = speed_multiplier
		mapod_state_machine.static_states_data["inertia"] = inertia
		mapod_state_machine.static_states_data["mouse_sensitivity"] = mouse_sensitivity
		mapod_state_machine.static_states_data["game_pad_sensitivity"] = game_pad_sensitivity
		mapod_state_machine.static_states_data["first_interaction"] = false
		mapod_state_machine.static_states_data["second_interaction"] = false
		mapod_state_machine.static_states_data["object_unique_id"] = 0
		mapod_state_machine.static_states_data["zoom"] = 1 / (camera.fov / max_fov)
		speed = mapod_state_machine.getStaticStatesData()["speed"].length()
	
	# hud and collision
	if hud:
		hud.set_speed_data(speed)
		hud.print_debug_msg("speed {s}".format({ "s": speed_to_string()}), 0)
		hud.print_debug_msg("", 2)
		_not_analysable()
		_disable_object_interaction()
		hud.set_first_interaction_info('')
		hud.set_second_interaction_info('')
		if ray_cast:
			if ray_cast.is_colliding():
				var collider_object = ray_cast.get_collider()
				if collider_object is BaseMapodObject:
					# collider is a mapod object
					hud.print_debug_msg("colliding BaseMapodObject", 2)
					var info = collider_object.informations()
					hud.set_first_interaction_info(info['first_interaction_info'])
					hud.set_second_interaction_info(info['second_interaction_info'])
					_set_object_interaction(info['first_interaction'], info['second_interaction'])
					hud.set_info_data(info['description'])
					mapod_state_machine.static_states_data["first_interaction"] = info['first_interaction']
					mapod_state_machine.static_states_data["second_interaction"] = info['second_interaction']
					mapod_state_machine.static_states_data["description"] = info['description']
					mapod_state_machine.static_states_data["object_unique_id"] = collider_object.get_unique_id()
				elif collider_object is MapodStaticBodyAnalyzable:
					# trovato un oggetto analizzabile
					var information = collider_object.information()
					var e_information = collider_object.e_information()
					hud.print_debug_msg("colliding %s" % information, 2)
					hud.set_info_data(information)
					var data_analysed = collider_object.open()
					if data_analysed["can_be_opened"]:
						mapod_state_machine.static_states_data["can_be_opened"] = true
						mapod_state_machine.static_states_data["scene_request_type"] = data_analysed["scene_request_type"]
						mapod_state_machine.static_states_data["request_scene"] = data_analysed["request_scene"]
						hud.set_e_info_data(e_information)
						hud.set_show_analysable(true, false)
				else:
					hud.print_debug_msg("colliding %s" % collider_object.get_class(), 2)


# ----- public methods

func set_debug_flag(value):
	debug_flag = value
	defer_debug_flag = value
	if hud:
		hud.set_debug(value)

# ----- private methods

# start object functions
func _set_object_interaction(first_flag: bool, second_flag: bool):
	hud.set_show_analysable(first_flag, second_flag)

func _disable_object_interaction():
	if hud:
		hud.set_info_data("")
		_set_object_interaction(false, false)
# end object functions

func _not_analysable():
	mapod_state_machine.static_states_data["can_be_opened"] = false
	if hud:
		hud.set_info_data("")
		hud.set_show_analysable(false, false)


# aggiorna un messaggio di debug
func _on_print_debug_msg_requested(msg: String, index: int):
	if hud:
		hud.print_debug_msg(msg, index)


func _on_move_requested(delta_speed: Vector3, new_speed: Vector3):
	speed = new_speed
	# print("%s %s" % [delta_speed, new_speed])
	var linear_speed_cx = transform.basis.x * delta_speed.x
	var linear_speed_cy = transform.basis.y * delta_speed.y
	var linear_speed_cz = -transform.basis.z * delta_speed.z
	var linear_speed = linear_speed_cz + linear_speed_cx + linear_speed_cy
	var _tmp = move_and_slide(linear_speed, Vector3.UP)


func _on_rotate_requested(relative: Vector2):
	rotation_helper.rotate_x(-deg2rad(relative.y))
	rotate_y(-deg2rad(relative.x))
	var camera_rot = rotation_helper.rotation_degrees
	camera_rot.x = clamp(camera_rot.x, -85, 85)
	rotation_helper.rotation_degrees = camera_rot


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


func _on_set_panorama_requested(stream_texture):
	request_panorama(stream_texture)


func _on_zoom_requested():
	if camera.fov > min_fov:
		camera.fov = camera.fov - 1


func _on_unzoom_requested():
	if camera.fov < max_fov:
		camera.fov = camera.fov + 1
