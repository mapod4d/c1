tool

# class_name

# extends
extends BaseMapodObject

# # docstring


# ----- signals

# ----- enums
enum Pos {
	RIGTH_UPPER = 0, 
	RIGTH_MIDDLE,
	RIGTH_DOWN,
	LEFT_UPPER, 
	LEFT_MIDDLE,
	LEFT_DOWN,
	UP_LEFT,
	UP_MIDDLE,
	UP_RIGHT,
	DOWN_LEFT,
	DOWN_MIDDLE,
	DOWN_RIGHT,
}

# ----- constants
const INFO_PATH = "MapodObjectInfoGeometry/Info"
const GEOMETRY_PATH = "MapodObjectInfoGeometry"
const COLLISION_PATH = "CollisionShape"

# ----- exported variables
export(PoolStringArray) var group_list
export(SpatialMaterial) var info_material
export var enable_show_groups:bool = true
export var enable_show_info:bool = true
export var show_groups:bool = false setget set_show_groups
export var show_info:bool = false setget set_show_info
export(float, 0.1, 1.0) var info_radius = 0.1 setget set_info_radius
export(Vector2) var info_size = Vector2(1.0, 1.0) setget set_info_size
export(Pos) var info_position = Pos.RIGTH_UPPER setget set_info_position


# ----- public variables

# ----- private variables

# ----- onready variables

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	show_groups = false
	show_info = false
	_set_all_info()
	_elab()

# ----- remaining built-in virtual methods

# ----- public methods

func do_first_interaction():
	if enable_show_groups == true:
		show_groups = true
	if enable_show_info == true:
		show_info = true
	_elab()


func do_second_interaction():
	if enable_show_groups == true:
		show_groups = false
	if enable_show_info == true:
		show_info = false
	_elab()


func set_show_groups(flag):
	show_groups = flag
	_elab()
	
func set_show_info(flag):
	show_info = flag
	_set_all_info()

func set_info_radius(value):
	info_radius = value
	_set_all_info()


func set_info_size(value):
	if value.x < 0.1:
		value.x = 0.1
	if value.y < 0.1:
		value.y = 0.1
	info_size = value
	_set_all_info()


func set_info_position(value):
	info_position = value
	_set_all_info()


# ----- private methods

func _elab():
	var value = "hide"
	if show_groups == true:
		value = "show"
	var tree = get_tree()
	if tree != null:
		for group_sel in group_list:
			tree.call_group(group_sel, value)
	_set_all_info()


func _set_all_info():
	var _info = get_node_or_null(INFO_PATH)
	var _geometry = get_node_or_null(GEOMETRY_PATH)
	var _collision = get_node_or_null(COLLISION_PATH)
	if _geometry != null:
		_geometry.radius = info_radius
	if _collision != null:
		_collision.shape.radius = info_radius
	if _info != null:
		if show_info == true:
			_info.visible = true
			if info_material != null:
				_info.set_surface_material(0, info_material)
			var info_transform = _info.transform.orthonormalized()
			# rotation
			info_transform.basis = Basis(Vector3(1, 0, 0), deg2rad(90))
			# scale
			info_transform = info_transform.scaled(
					Vector3(info_size.x, info_size.y, 1.0))
			# origin
			match(info_position):
				Pos.RIGTH_UPPER:
					info_transform.origin = Vector3(
							info_radius + (info_size.x / 2.0),
							(info_size.y / 2.0),
							0.0
					)
				Pos.RIGTH_MIDDLE:
					info_transform.origin = Vector3(
							info_radius + (info_size.x / 2.0),
							0.0,
							0.0
					) 			
				Pos.RIGTH_DOWN:
					info_transform.origin = Vector3(
							info_radius + (info_size.x / 2.0),
							-(info_size.y / 2.0),
							0.0
					)
				Pos.LEFT_UPPER:
					info_transform.origin = Vector3(
							-(info_radius + (info_size.x / 2.0)),
							(info_size.y / 2.0),
							0.0
					)
				Pos.LEFT_MIDDLE:
					info_transform.origin = Vector3(
							-(info_radius + (info_size.x / 2.0)),
							0.0,
							0.0
					) 			
				Pos.LEFT_DOWN:
					info_transform.origin = Vector3(
							-(info_radius + (info_size.x / 2.0)),
							-(info_size.y / 2.0),
							0.0
					)
				Pos.UP_LEFT:
					info_transform.origin = Vector3(
							-(info_size.x / 2.0),
							info_radius + (info_size.y / 2.0),
							0.0
				)
				Pos.UP_MIDDLE:
					info_transform.origin = Vector3(
							0.0,
							info_radius + (info_size.y / 2.0),
							0.0
				)
				Pos.UP_RIGHT:
					info_transform.origin = Vector3(
							info_size.x / 2.0,
							info_radius + (info_size.y / 2.0),
							0.0
				)
				Pos.DOWN_LEFT:
					info_transform.origin = Vector3(
							-(info_size.x / 2.0),
							-(info_radius + (info_size.y / 2.0)),
							0.0
				)
				Pos.DOWN_MIDDLE:
					info_transform.origin = Vector3(
							0.0,
							-(info_radius + (info_size.y / 2.0)),
							0.0
				)
				Pos.DOWN_RIGHT:
					info_transform.origin = Vector3(
							info_size.x / 2.0,
							-(info_radius + (info_size.y / 2.0)),
							0.0
				)
			_info.transform = info_transform
		else:
			_info.visible = false
