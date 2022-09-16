class_name BaseMapodMenuLabel
extends Label


# ----- signals
signal mouse_left_click_received()

# ----- enums

# ----- constants
enum SPECIALCODES {
	NONE, EXIT
}

# ----- exported variables
export(String, FILE, "*.tscn") var scene = null
export(SPECIALCODES) var special = SPECIALCODES.NONE
export(MapodUtils.MAPODSCENETYPES) var scene_type = MapodUtils.MAPODSCENETYPES.MAPODPLANET
export(bool) var active = true

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- built-in virtual _ready method


# ----- remaining built-in virtual methods
func _input(event):
	if event.is_action_pressed("mapod_click"):
		pass
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			# print("LABEL %s" % get_name())
			_mouse_left_click()

# ----- public methods

func get_special():
	return special

func get_scene_type():
	return scene_type

func call_back():
	return scene

# ----- private methods

func _mouse_left_click():
	emit_signal("mouse_left_click_received")
