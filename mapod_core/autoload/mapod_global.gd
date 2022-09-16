extends Node


# ----- signals
signal progress_bar_show_requested(progress)
signal progress_bar_update_requested(value)
signal new_scene_loaded(scene)

# ----- enums
#enum MAPODSCENETYPE {
#	MAPODMAIN,
#	MAPODLEVEL,
#	MAPODDATA,
#}

enum MAPODSCENEREQUESTTYPE {
	STANDARDRQS,
	PUSHRQS,
	POPRQS,
}

# type of object
enum MAPODOBJECTTYPE {
	OPENSCENE,
	UPDOWN,
}

# ----- constants

# ----- exported variables

# ----- public variables
var utils = null
var time_max = 200000 # msec timeout load scene
var time_min = 1000 # msec min time load scene
var metaverse = null #"res://main/metaverse/metaverse.tscn"
#var prefix_main = "res://main/"
var mapod_core_res = null #"res://main/mapod_core/mapod_core.tscn" # core di gestione derivato
var start_scene_name = null
var already_set_start_scene = false
var active = false
var loader = null
var wait_frames
var current_scene = null
var start_tick = 0

# ----- private variables
var _stack_scenes_status = []
var _current_scene_name = null

# ----- onready variables
# per controllare se mapodCore e' la scena root
# onready var mapod_core: BaseMapodCore = get_node_or_null("/root/MapodCore")
onready var mapod_core = get_node_or_null("/root/MapodCore")

# ----- built-in virtual _ready method

func _ready():
	print("mapod_global._ready")
	set_process(false)
	utils = MapodUtils.new()
	metaverse = utils.path_scene("mapod_metaverse", MapodUtils.MAPODSCENETYPES.MAPODMAIN)
	mapod_core_res = utils.path_scene("mapod_core", MapodUtils.MAPODSCENETYPES.MAPODMAIN)
	# se mapodCore non e' la scena root ne forza il caricamento
	# usato per F6
	if mapod_core == null:
		print("mapod_global._ready mapod_core==null")
		call_deferred("_start_not_mapod_core")
	else:
		mapod_core.connect("scene_requested", self, "_on_scene_requested")
		mapod_core.connect("metaverse_requested", self, "_on_metaverse_requested")
		mapod_core.connect("push_scene_requested", self, "_on_push_scene_requested")
		mapod_core.connect("pop_scene_requested", self, "_on_pop_scene_requested")
		connect("progress_bar_update_requested", mapod_core, "_on_progress_bar_update_requested")
		connect("progress_bar_show_requested", mapod_core, "_on_progress_bar_show_requested")
		connect("new_scene_loaded", mapod_core, "_on_new_scene_loaded")
	active = true


# ----- remaining built-in virtual methods

func _process(_delta):
	if loader == null:
		# nulla da caricare
		set_process(false)
	else:
		var current_tick = OS.get_ticks_msec()
		if (current_tick < start_tick + time_max) or (current_tick < start_tick + time_min):
			var poll_response = loader.poll()
			if poll_response == ERR_FILE_EOF:
				# almeno un time_min di visualizzazione
				if current_tick > start_tick + time_min:
					# caricamento finito
					var scene = loader.get_resource()
					_set_new_scene(scene)
					_hide_progress_bar()
					loader = null
				else:
					var progress = float(current_tick) / (start_tick + time_min) 
					_update_progress(progress)
			elif poll_response == OK:
				var progress = float(loader.get_stage()) / loader.get_stage_count()
				_update_progress(progress)
			else:
				_show_error("ERROR 1")
				loader = null


# ----- private methods

func _start_not_mapod_core():
	# carica in ogni caso la scena mapodCore come root
	# e appende la scena corrente a loadScene
	# serve quando si carica una singola scena per
	# avere il corretto contesto, per esempio con F6 durante lo sviluppo
	var played_scene = get_tree().current_scene
	# workaroung bake problem
	yield(get_tree().create_timer(0.5), "timeout")
	var root = get_node("/root")
	mapod_core = load(mapod_core_res).instance()
	root.remove_child(played_scene)
	root.add_child(mapod_core)
	mapod_core.owner = root
	# clean loadScene
	var loaded_scene = mapod_core.get_node("LoadedScene")
	var child_zero = loaded_scene.get_child(0)
	if child_zero != null:
		child_zero.queue_free()
	# add played scene
	loaded_scene.add_child(played_scene)
	played_scene.owner = loaded_scene
	current_scene = played_scene
	#if current_scene is BaseMapodLevel:
	#	current_scene.connect("scene_requested", self, "_on_scene_requested")
	#	current_scene.connect("push_scene_requested", self, "_on_push_scene_requested")
	#	current_scene.connect("pop_scene_requested", self, "_on_pop_scene_requested")
	connect("new_scene_loaded", mapod_core, "_on_new_scene_loaded")
	emit_signal("new_scene_loaded", current_scene)


func _hide_progress_bar():
	emit_signal("progress_bar_show_requested", false)


func _start_progress_bar():
	emit_signal("progress_bar_update_requested", 0)
	emit_signal("progress_bar_show_requested", true)


func _update_progress(progress):
	if loader != null:
		emit_signal("progress_bar_update_requested", progress)


func _set_new_scene(scene):
	var loadedScene = get_node("/root/MapodCore/LoadedScene")
	current_scene = scene.instance()
	if current_scene != null:
		loadedScene.add_child(current_scene)
		current_scene.set_owner(loadedScene)
		emit_signal("new_scene_loaded", current_scene)
	else:
		print("cannot instance scene %s" % scene)


func _show_error(msg):
	print(msg)
	return msg


func _internal_scene_requested(scene_name, request_type: int):
	var push_data = {
		"scene_name": null
	}
	if scene_name != null:
		print("MAPOD GLOBAL _on_scene_requested %s" % scene_name)
		loader = ResourceLoader.load_interactive(scene_name)
		if loader == null:
			_show_error("MAPOD GLOBAL _on_scene_requested %s cannot load resource" % scene_name)
		else:
			if already_set_start_scene == false:
				start_scene_name = scene_name
				already_set_start_scene = true
			start_tick = OS.get_ticks_msec()
			_start_progress_bar()
			set_process(true)
			if current_scene != null:
				if request_type == MAPODSCENEREQUESTTYPE.PUSHRQS:
					# save data for push
					push_data["scene_name"] = _current_scene_name
				_current_scene_name = scene_name
				current_scene.queue_free()
				if request_type == MAPODSCENEREQUESTTYPE.PUSHRQS:
					# save data player
					# push to stack
					_stack_scenes_status.push_back(push_data)


func _on_scene_requested(scene_name):
	_internal_scene_requested(scene_name, MAPODSCENEREQUESTTYPE.STANDARDRQS)

func _on_metaverse_requested():
	_internal_scene_requested(metaverse, MAPODSCENEREQUESTTYPE.STANDARDRQS)

func _on_push_scene_requested(scene_name):
	_internal_scene_requested(scene_name, MAPODSCENEREQUESTTYPE.PUSHRQS)


func _on_pop_scene_requested():
	var scene_status = _stack_scenes_status.pop_back()
	if scene_status != null:
		_internal_scene_requested(
			scene_status["scene_name"],
			MAPODSCENEREQUESTTYPE.POPRQS
		)
	else:
		pass

