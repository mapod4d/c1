# tool

# class_name

# extends
extends MeshInstance

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(String, MULTILINE) var _mapod_information = "Nessuna informazione disponibile"
export(String) var _mapod_e_information = "Nessuna informazione disponibile"
export(String, FILE, "*.tscn") var _mapod_request_scene = ""

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	var body = _getBody()
	if body != null:
		body.set_information(_mapod_information)
		body.set_e_information(_mapod_e_information)
		body.set_request_scene(_mapod_request_scene)

# ----- remaining built-in virtual methods

# ----- public methods

func set__mapod_information(value):
	var body = _getBody()
	if body != null:
		body.set_information(value)


func set__mapod_e_information(value):
	var body = _getBody()
	if body != null:
		body.set_e_information(value)


func set__mapod_request_scene(value):
	var body = _getBody()
	if body != null:
		body.set_request_scene(value)

# ----- private methods

func _getBody():
	return get_node_or_null("PortalStaticBody")
