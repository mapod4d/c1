# tool
tool

# class_name
class_name Mapod2DPlanetScene

# extends
extends Mapod2DScene

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(bool) var observer_activated = true
export(Vector2) var observer_position = Vector2(0, 0)
export(int) var width_size = 1920 setget _set_width_size
export(int) var height_size = 1080 setget _set_height_size

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

func _process(_delta):
	_set_terrain_size()

# ----- public methods

func activate_observer():
	return observer_activated


func get_2d_observer_position():
	return observer_position


func get_2d_view_width():
	return width_size


func get_2d_view_height():
	return height_size


# ----- private methods

func _set_width_size(value):
	width_size = value
	_set_terrain_size()


func _set_height_size(value):
	height_size = value
	_set_terrain_size()


func _set_terrain_size():
	var terrain = get_node_or_null("Terrain")
	if terrain:
		var size = Vector2(width_size, height_size)
		terrain.rect_size = size
