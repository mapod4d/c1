class_name BaseMapodCore
extends Node


# ----- signals
signal metaverse_requested()
signal scene_requested(scene_name)
signal push_scene_requested(scene_name)
signal pop_scene_requested()

# ----- enums

# ----- constants

# ----- exported variables
export(String, FILE, "*.tscn") var start_scene_res = "res://main/mapod_main_menu/mapod_main_menu.tscn"
export(String, FILE, "*.tscn") var visitor_res = "res://main/mapod_visitor/mapod_visitor.tscn"
export(String, FILE, "*.tscn") var observer_res = "res://main/mapod_observer/mapod_observer.tscn"

# ----- public variables
var current_scene = null

# ----- private variables

# ----- onready variables
onready var load_scene = $LoadedScene
onready var utils = $Utils
onready var progress_bar = $Utils/Progress


# ----- built-in virtual _ready method
func _ready():
	print("mapod_core._ready")
	# hides Utils child
	if utils != null:
		for child in utils.get_children():
			if "visible" in child:
				child.visible = false
	emit_signal("scene_requested", start_scene_res)


# ----- private methods

# nuova scena caricata
func _on_new_scene_loaded(scene):
	print(scene)
	current_scene = scene
	if current_scene is BaseMapod2D3DScene:
		current_scene.connect("metaverse_requested", self, "_on_metaverse_requested")
		current_scene.connect("scene_requested", self, "_on_scene_requested")
		current_scene.connect("push_scene_requested", self, "_on_push_scene_requested")
		current_scene.connect("pop_scene_requested", self, "_on_pop_scene_requested")
		
	if current_scene is MapodPlanetScene:
		if current_scene.activate_visitor():
			# search for building
			var building = current_scene.get_node_or_null("Terrain/Buildings")
			if building != null:
				# player activation (visitor)
				var player = load(visitor_res)
				if player != null:
					player = player.instance()
					player.mapod_set_3d_start_position(current_scene.mapod_3d_start_position())
					if player is BaseMapodPlayer:
						player.connect("metaverse_requested", self, "_on_metaverse_requested")
						player.connect("scene_requested", self, "_on_scene_requested")
						player.connect("push_scene_requested", self, "_on_push_scene_requested")
						player.connect("pop_scene_requested", self, "_on_pop_scene_requested")
						player.connect("set_panorama_requested", self, "_on_set_panorama_requested")
						player.connect("object_first_interaction_requested", self, "_on_object_first_interaction_requested")
						player.connect("object_second_interaction_requested", self, "_on_object_second_interaction_requested")
					current_scene.add_child(player)
					player.set_owner(current_scene)
					
				else:
					print("base_mapod_core.gd Visitor not found !")
			else:
				print("base_mapod_core.gd Buildings not found !")

	if current_scene is Mapod2DPlanetScene:
		if current_scene.activate_observer():
			var terrain = current_scene.get_node_or_null("Terrain")
			if terrain != null:
				# player activation (observer)
				var player = load(observer_res)
				if player != null:
					player = player.instance()
					var player_position = current_scene.mapod_2d_start_position()
					var root_viewport = get_viewport()
					if root_viewport != null:
						player_position = player.calc_position(player_position, root_viewport.size)
					player.mapod_set_2d_start_position(player_position)
					var width = current_scene.get_2d_view_width()
					var height = current_scene.get_2d_view_height()
					player.mapod_set_2d_limits(width, height)
					if player is BaseMapodPlayer2D:
						player.connect("metaverse_requested", self, "_on_metaverse_requested")
						player.connect("scene_requested", self, "_on_scene_requested")
						player.connect("push_scene_requested", self, "_on_push_scene_requested")
						player.connect("pop_scene_requested", self, "_on_pop_scene_requested")
					current_scene.add_child(player)
					player.set_owner(current_scene)
				else:
					print("base_mapod_core.gd Observer not found !")
			else:
				print("base_mapod_core.gd Buildings not found !")


# mostra la videata di caricamento
func _on_progress_bar_show_requested(value: bool):
	progress_bar.visible = value


# setta il valore della progress bar nella videata di caricamento
func _on_progress_bar_update_requested(progress):
	progress_bar.mapod_progress_value(progress)


func _on_metaverse_requested():
	emit_signal("metaverse_requested")


func _on_scene_requested(scene_name):
	emit_signal("scene_requested", scene_name)


func _on_push_scene_requested(scene_name):
	emit_signal("push_scene_requested", scene_name)


func _on_pop_scene_requested():
	emit_signal("pop_scene_requested")


func _on_set_panorama_requested(stream_texture):
	print("base_mapod_core.gd _on_set_panorama_requested")
	if current_scene is MapodPlanetScene:
		current_scene.set_panorama(stream_texture)


# first interaction from object
func _on_object_first_interaction_requested(object_uid: int):
	if current_scene is MapodPlanetScene:
		current_scene.mapod_object_first_interaction(object_uid)


# second interaction from object
func _on_object_second_interaction_requested(object_uid: int):
	if current_scene is MapodPlanetScene:
		current_scene.mapod_object_second_interaction(object_uid)

