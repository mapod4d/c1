# tool

# class_name
class_name MapodPlanetScene

# extends
extends MapodScene

# planets lodader
# Loand planet 2D or 3D and attach the visitor
# or the observer

# ----- signals

# ----- enums


# ----- constants

# ----- exported variables
export(bool) var visitor_activated = true
export(Vector3) var visitor_position = Vector3(0, 1.75, 0)
export(Vector3) var visitor_angle = Vector3(0, 270, 0)

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

func _input(_event):
	#if event.is_action_pressed("ui_accept"):
	#	emit_signal("gotoScene", startSceneName)
	pass


# ----- public methods

func activate_visitor():
	return visitor_activated


func mapod_3d_start_position():
	return [visitor_position, visitor_angle]


func mapod_object_action_requested(object_uid: int, action: String, params):
	print("#### REQUEST")
	print("#### UID %d" % object_uid)
	print("#### ACTION %s" % action)
	if action == "panorama":
		if params is BaseResMapodPansky:
			set_panorama_and_rotation(params.img, params.angles)


# add new panorama
func set_panorama(stream_texture):
	var world_environment = get_node_or_null("WorldEnvironment")
	if world_environment != null:
		var planet_environment = world_environment.environment
		if planet_environment != null:
			if planet_environment.background_mode == Environment.BG_SKY:
				var panorama = PanoramaSky.new()
				panorama.set_panorama(stream_texture)
				planet_environment.set_sky(panorama)


# add new panorama and rotation
func set_panorama_and_rotation(stream_texture, rotation: Vector3):
	var world_environment = get_node_or_null("WorldEnvironment")
	if world_environment != null:
		var planet_environment = world_environment.environment
		if planet_environment != null:
			if planet_environment.background_mode == Environment.BG_SKY:
				var panorama = PanoramaSky.new()
				panorama.set_panorama(stream_texture)
				planet_environment.set_sky(panorama)
				planet_environment.set_sky_rotation(rotation)
				

# ----- private methods
