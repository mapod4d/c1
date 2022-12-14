# tool

# class_name
class_name BaseMapodObject

# extends
extends StaticBody

# # docstring


# ----- signals
# send an action request
signal object_action_requested(unique_id, action, params)

# ----- enums

# ----- constants

# ----- exported variables
export(String) var mapod_o_name = 'nessun nome'

export(String, MULTILINE) var mapod_o_description = ''

export(bool) var mapod_o_first_interaction = false
export(String) var mapod_o_first_interaction_info = 'Nessuna informazione'

export(bool) var mapod_o_second_interaction = false
export(String) var mapod_o_second_interaction_info = 'Nessuna informazione'

# ----- public variables

# ----- private variables
var _unique_id = 0

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	add_to_group("mapod_objects")
	_collision_update()
	connect("visibility_changed", self, "_on_visibility_chage")


# ----- remaining built-in virtual methods

# ----- public methods

# object informations
func informations():
	var retVal = {
		'name': mapod_o_name,
		'description': mapod_o_description,
		'first_interaction': mapod_o_first_interaction,
		'first_interaction_info': mapod_o_first_interaction_info,
		'second_interaction': mapod_o_second_interaction,
		'second_interaction_info': mapod_o_second_interaction_info,
	}
	return retVal


func assign_unique_id(unique_id: int):
	_unique_id = unique_id


func get_unique_id():
	return _unique_id


func do_first_interaction():
	#print("mapod first interaction object id %d" % _unique_id)
	pass


func do_second_interaction():
	#print("mapod second interaction object id %d" % _unique_id)
	pass

# ----- private methods

func _object_action_request(unique_id: int, action: String, params):
	emit_signal("object_action_requested", unique_id, action, params)


func _on_visibility_chage():
	_collision_update()


func _collision_update():
	for child_node in self.get_children():
		if child_node is CollisionShape:
			child_node.disabled = !visible
