tool

# class_name

# extends
extends Spatial

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(Resource) var textureImage = null setget get_texture_image

# ----- public variables

# ----- private variables

# ----- onready variables
onready var panel = $Panel

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	if Engine.is_editor_hint():
		pass
	else:
		if textureImage != null:
			var material = SpatialMaterial.new()
			material.albedo_color = Color.white
			material.albedo_texture = textureImage
			panel.set_surface_material(0, material)

# ----- remaining built-in virtual methods

# ----- public methods

func get_texture_image(data):
	if data is StreamTexture:
		textureImage = data
	else:
		print("this data must be StreamTexture !!!!!!!")

# ----- private methods
