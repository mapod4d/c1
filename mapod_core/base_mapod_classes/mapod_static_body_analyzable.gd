# tool

# class_name
class_name MapodStaticBodyAnalyzable

# extends
extends StaticBody

# # docstring


# ----- signals
#signal observed

# ----- enums

# ----- constants

# ----- exported variables
export(String, MULTILINE) var _mapod_information = "Nessuna informazione disponibile"
export(String) var _mapod_e_information = "Nessuna informazione disponibile"
export(bool) var _mapod_can_be_opened = false
export(bool) var _mapod_can_be_opened_ext = false
export(MapodGlobal.MAPODSCENEREQUESTTYPE) var _mapod_scene_request_type = MapodGlobal.MAPODSCENEREQUESTTYPE.STANDARDRQS
export(MapodGlobal.MAPODOBJECTTYPE) var _mapod_object_type = MapodGlobal.MAPODOBJECTTYPE.OPENSCENE
export(String, FILE, "*.tscn") var _mapod_request_scene = ""

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

# ----- public methods

func set_information(value: String):
	_mapod_information = value


func information():
	var retVal = ""
	if _mapod_information != null:
		retVal = _mapod_information
	return retVal


func set_e_information(value: String):
	_mapod_e_information = value


func e_information():
	var retVal = ""
	if _mapod_e_information != null:
		retVal = _mapod_e_information
	return retVal


func set_can_be_opened(value: bool):
	_mapod_can_be_opened = value


func set_scene_request_type(value: int):
	_mapod_scene_request_type = value


func set_request_scene(value: String):
	_mapod_request_scene = value


func open():
	var retVal = {
		"can_be_opened": false,
		"can_be_opened_ext": _mapod_can_be_opened_ext,
		"scene_request_type": _mapod_scene_request_type,
		"request_scene": _mapod_request_scene,
	}
	# check data 
	if _mapod_scene_request_type == MapodGlobal.MAPODSCENEREQUESTTYPE.STANDARDRQS:
		if _mapod_request_scene != null:
			if _mapod_request_scene.length() > 0:
				retVal["can_be_opened"] = _mapod_can_be_opened
	elif _mapod_scene_request_type == MapodGlobal.MAPODSCENEREQUESTTYPE.PUSHRQS:
		if _mapod_request_scene != null:
			if _mapod_request_scene.length() > 0:
				retVal["can_be_opened"] = _mapod_can_be_opened
	elif _mapod_scene_request_type == MapodGlobal.MAPODSCENEREQUESTTYPE.POPRQS:
		retVal["can_be_opened"] = _mapod_can_be_opened
	return retVal

# ----- private methods

func _getBody():
	return null
