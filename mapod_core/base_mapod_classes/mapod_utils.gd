# tool

# class_name
class_name MapodUtils
# extends
extends Node

# # docstring


# ----- signals

# ----- enums
enum MAPODSCENETYPES {
	MAPODMAIN, MAPODPLANET, MAPODSERVICE
}

# ----- constants
const base_main_scenes_path = "res://main/{dir}/{name}.tscn"
const base_planet_scenes_path = "res://metaverse/planets/{dir}/{name}.tscn"
const base_service_scenes_path = "res://metaverse/services/{dir}/{name}.tscn"

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

# ----- public methods
func path_scene(scene_name: String, scene_type: int):
	var retVal = null
	if scene_type == MAPODSCENETYPES.MAPODMAIN:
		retVal = base_main_scenes_path.format({"dir": scene_name, "name": scene_name})
	elif scene_type == MAPODSCENETYPES.MAPODPLANET:
		retVal = base_planet_scenes_path.format({"dir": scene_name, "name": scene_name})
	elif scene_type == MAPODSCENETYPES.MAPODSERVICE:
		retVal = base_main_scenes_path.format({"dir": scene_name, "name": scene_name})
	return retVal

# ----- private methods
