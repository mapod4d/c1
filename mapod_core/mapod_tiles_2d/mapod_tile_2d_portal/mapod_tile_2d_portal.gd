# tool
tool

# class_name

# extends
extends Node2D

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(String) var _mapod_title = "Nessun titolo" setget set__mapod_title
export(String, MULTILINE) var _mapod_information = "Nessuna informazione disponibile" setget set__mapod_information
export(String) var _mapod_e_information = "Nessuna informazione disponibile" setget set__mapod_e_information
export(String, FILE, "*.tscn") var _mapod_request_scene = "" setget set__mapod_request_scene
export(String) var _info_path = "Percorso di STUDIO" setget set__info_path
export(bool) var _path_visible_flag = false setget set__path_visible_flag

# ----- public variables

# ----- private variables

# ----- onready variables
onready var title = $PanelTitle/Title
onready var path_panel = $PathTypePanel
onready var path_type = $PathTypePanel/PathType
onready var portal = $Body2DPortal


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	portal.set__mapod_information(_mapod_information)
	portal.set__mapod_e_information(_mapod_e_information)
	portal.set__mapod_request_scene(_mapod_request_scene)
	path_panel.visible = _path_visible_flag
	path_type.text = _info_path
	title.text = _mapod_title

# ----- remaining built-in virtual methods

func _process(_delta):
	if Engine.is_editor_hint():
		if title != null:
			title.text = _mapod_title
		if path_panel != null:
			path_panel.visible = _path_visible_flag
		if path_type != null:
			path_type.text = _info_path

# ----- public methods

func set__mapod_title(value):
	_mapod_title = value
	if title != null:
		title.text = value


func set__mapod_information(value):
	_mapod_information = value
	if portal != null:
		portal.set__mapod_information(value)


func set__mapod_e_information(value):
	_mapod_e_information = value
	if portal != null:
		portal.set__mapod_e_information(value)


func set__mapod_request_scene(value):
	_mapod_request_scene = value
	if portal != null:
		portal.set__mapod_request_scene(value)


func set__info_path(value: String):
	_info_path = value
	if path_type != null:
		path_type.text = value


func set__path_visible_flag(value: bool):
	_path_visible_flag = value
	if path_panel != null:
		path_panel.visible = value

# ----- private methods
