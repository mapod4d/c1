tool

# class_name

# extends
extends Spatial

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
#export(Resource) var textureImage = null setget get_texture_image
#export(Resource) var portrait_texture_image = null setget set_portrait_texture_image
export(Texture) var portrait_texture_image = null setget set_portrait_texture_image
export(Texture) var data_texture_image = null setget set_data_texture_image

# ----- public variables

# ----- private variables
var _portrait_texture_image = null
var _data_texture_image = null

# ----- onready variables
onready var panel = $PortraitCreditInfo

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	_assign_portrait_texture_image()
	_assign_data_texture_image()

# ----- remaining built-in virtual methods

func _process(delta):
	if Engine.is_editor_hint():
		_assign_portrait_texture_image()
		_assign_data_texture_image()

# ----- public methods

func set_portrait_texture_image(data):
	if data != null:
		if data is StreamTexture:
			_portrait_texture_image = data
			portrait_texture_image = data
			_assign_portrait_texture_image()
		else:
			print("portrait_texture_image must be StreamTexture !!!!!!!")
	else:
		_portrait_texture_image = null
		portrait_texture_image = null
		

func set_data_texture_image(data):
	if data != null:
		if data is StreamTexture:
			_data_texture_image = data
			data_texture_image = data
			_assign_data_texture_image()
		else:
			print("data_texture_image must be StreamTexture !!!!!!!")
	else:
		_data_texture_image = null
		data_texture_image = null

# ----- private methods

func _assign_portrait_texture_image():
	if _portrait_texture_image != null:
		var panel = get_node_or_null("PortraitCreditInfo")
		if panel != null:
			var material = panel.get_surface_material(2)
			var new_material = material.duplicate(true)
			new_material.set_shader_param("base_texture", _portrait_texture_image)
			panel.set_surface_material(2, new_material)


func _assign_data_texture_image():
	if _data_texture_image != null:
		var panel = get_node_or_null("PortraitCreditInfo")
		if panel != null:
			var material = panel.get_surface_material(1)
			var new_material = material.duplicate(true)
			new_material.set_shader_param("base_texture", _data_texture_image)
			panel.set_surface_material(1, new_material)
