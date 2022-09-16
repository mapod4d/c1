# tool
tool

# class_name

# extends
extends BaseMapodObject

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
#export(NodePath) var target = null setget _set_target
export(NodePath) var target = null
export(Vector3) var up_translate = Vector3(0, 0, 0)

# ----- public variables

# ----- private variables
var _up_position = false

# ----- onready variables

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# ----- remaining built-in virtual methods

# ----- public methods
func do_first_interaction():
	if _up_position == false:
		if target != null:
			var data_node = get_node_or_null(target)
			if data_node != null:
				if data_node is Spatial:
					data_node.translate(up_translate)
					_up_position = true

func do_second_interaction():
	if _up_position == true:
		if target != null:
			var data_node = get_node_or_null(target)
			if data_node != null:
				if data_node is Spatial:
					data_node.translate(-up_translate)
					_up_position = false
	

# ----- private methods

#func _set_target(data):
#	if data == null:
#		target = data
#	elif data == "":
#		target = data
#	else:
#		if Engine.editor_hint:
#			var data_node = get_node_or_null(data)
#			if data_node != null:
#				if data_node is Spatial:
#					target = data
#				else:
#					print("Error: target must be Spatial node")
#			else:
#				print("Error: target must be existent Spatial node")
#		else:
#			target = data

