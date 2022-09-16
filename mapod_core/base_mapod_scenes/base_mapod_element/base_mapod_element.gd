# tool

# class_name
class_name BaseMapodElement

# extends
extends Spatial

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
var description = "NO DESCRIPTION"

# ----- private variables

# ----- onready variables
onready var title = $Model/Viewport/Label
onready var static_body = $Model/MapodElementSB


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	title.text = description

# ----- remaining built-in virtual methods

# ----- public methods

func set_data(info: String, e_info: String, scene_name: String):
	if static_body != null:
		static_body.set_information(info)
		static_body.set_e_information(e_info)
		static_body.set_request_scene(scene_name)
		static_body.set_can_be_opened(true)


func set_description(descr: String):
	description = descr
	title.text = description


func set_description_color(color: Color):
	title.set("custom_colors/font_color", color)

# ----- private methods
