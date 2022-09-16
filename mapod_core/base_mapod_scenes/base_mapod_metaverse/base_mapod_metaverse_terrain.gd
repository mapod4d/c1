# tool

# class_name

# extends
extends Spatial

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(Array, Resource) var elements = []

# ----- public variables

# ----- private variables

# ----- onready variables
onready var mapod_planet_model = "res://mapod_core/mapod_scenes/mapod_planet_model/mapod_planet_model.tscn"
onready var mapod_2d_planet_model = "res://mapod_core/mapod_scenes/mapod_2d_planet_model/mapod_2d_planet_model.tscn"
onready var mapod_mind_model = "res://mapod_core/mapod_scenes/mapod_mind_model/mapod_mind_model.tscn"
onready var table = $Buildings/Table

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	var utils = MapodUtils.new()
	var z_pos = 0
	var n_valid = 0
	for element in elements:
		if element is BaseResMapodElement:
			if element.mapod_requested_scene != null:
				if ResourceLoader.exists(element.mapod_requested_scene):
					var planet = null
					if element.element_type == 0: # 3DPlanet
						planet = load(mapod_planet_model).instance()
					elif element.element_type == 1: # 2DPlanet
						planet = load(mapod_2d_planet_model).instance()
					elif element.element_type == 2: # 2DPlanet
						planet = load(mapod_mind_model).instance()
				
					if planet != null:
						self.add_child(planet)
						planet.set_description(element.description)
						planet.set_description_color(element.description_color)
						planet.set_data(
							element.information,
							"per entrare nel planet",
							element.mapod_requested_scene
						)
						planet.owner = self
						planet.translation.z = z_pos
						z_pos += 6
						n_valid += 1
	if n_valid > 0:
		table.mesh.size.z = 6 * n_valid 
		table.translation.z = (6 * (n_valid - 1)) / 2

# ----- remaining built-in virtual methods

# ----- public methods

# ----- private methods
