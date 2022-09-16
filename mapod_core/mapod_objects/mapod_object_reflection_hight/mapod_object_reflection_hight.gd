# tool

# class_name

# extends
extends BaseMapodObject

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(Array, Resource) var image_list
export(int) var default_index = 0

# ----- public variables

# ----- private variables
var _image_list = []
var _max = 0
var _current_index = 0
var _flag_already_interacted = false

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	for element in image_list:
		if element is BaseResMapodPansky:
			_image_list.append(element)
	_max = len(_image_list)
	if _max > 0:
		if default_index < 0:
			default_index = 0
		if default_index >= _max:
			default_index = _max - 1
	else:
		default_index = 0

# ----- remaining built-in virtual methods

# ----- public methods

func do_first_interaction():
	#var texture = ImageTexture.new()
	#var image = Image.new()
	#image.load("res://assets/images/outdoor_hdri006_8k-tonemapped.jpg")
	#texture.create_from_image(image)
	#print("mapod first interaction object id %d" % _unique_id)
	if _max > 0:
		if _flag_already_interacted == false:
			_current_index = default_index
			_flag_already_interacted = true
		if _current_index > 0:
			_current_index -= 1
		var texture = _image_list[_current_index]
		emit_signal("object_action_requested", _unique_id, "panorama", texture)


func do_second_interaction():
	#print("mapod second interaction object id %d" % _unique_id)
	if _max > 0:
		if _flag_already_interacted == false:
			_current_index = default_index
			_flag_already_interacted = true
		_current_index += 1
		if _current_index >= _max:
			_current_index = _max - 1
		var texture = _image_list[_current_index]
		emit_signal("object_action_requested", _unique_id, "panorama", texture)

# ----- private methods
