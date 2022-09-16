class_name BaseMapodMainMenu
extends BaseMapod2D3DScene


# ----- signals

# ----- enums

# ----- constants
const SCENE_EXIT = "EXIT"

# ----- exported variables
export(String) var sub_title_text = ""
export(StyleBoxFlat) var label_style_nomouse = null
export(StyleBoxFlat) var label_style_mouse = null
export(float) var debounce_time = 1.0
export(String, FILE, "*.tres") var version_res = "res://main/mapod_version/mapod_version.tres"

# ----- public variables
var menu_name = "ColorRect/MarginContainer/HBoxContainer/MarginContainer/LeftBox/Menu"
var sub_title_name = "ColorRect/MarginContainer/HBoxContainer/MarginContainer/LeftBox/Header/SubTitle"
var selected_node = null
var sub_title = null
var mouse_current_node = null
var disable_input = false

# ----- private variables

# ----- onready variables
onready var menu = get_node_or_null(menu_name)
onready var menu_selector = $MenuSelector
onready var debouncer = $Debouncer
onready var version_data = $ColorRect/MarginContainer/HBoxContainer/MarginContainer/LeftBox/MarginContainer/VBoxContainer/VersionData

# ----- built-in virtual _ready method

func _ready():
	if menu == null:
		print("Menu' not found")
	else:
		# init debouncer
		debouncer.wait_time = debounce_time
		debouncer.one_shot = true
		debouncer.connect("timeout", self, "_on_timeout")
		sub_title = get_node_or_null(sub_title_name)
		# configura il sottotitolo
		if sub_title != null:
			sub_title.text = sub_title_text
		# configura la versione
		var version_info = load(version_res)
		if version_info:
			var versione_string = "VER. APP. %s VER. ENG. %s" % [version_info.mapod_app_version, version_info.mapod_engine_version ]
			version_data.text = versione_string
		else:
			version_data.text = "VERSIONE NON TROVATA !!!"
		# calcola le posizioni
		for node in menu.get_children():
				if node is BaseMapodMenuLabel:
					node.mouse_filter = Control.MOUSE_FILTER_PASS
					if node.active == true:
						var x = node.get_global_position().x
						x -= (menu_selector.scale.x * menu_selector.get_rect().size.x)/2
						x -= menu_selector.margin_x
						var y = node.get_global_position().y
						y += (node.rect_scale.y * node.rect_size.y)/2
						var position = Vector2(x, y)
						menu_selector.selections_positions.append(position)
						menu_selector.selections_names.append(node.name)
						node.connect("mouse_entered", self, "_on_mouse_entered", [node])
						node.connect("mouse_exited", self, "_on_mouse_exited", [node])
						node.connect("mouse_left_click_received", self, "_on_mouse_left_click_received")
		menu_selector.connect("selection_changed", self, "_on_selection_changed")
		menu_selector.set_selection(0)


# ----- remaining built-in virtual methods

func _input(event):
	# fullscreen/ window
	if event.is_action_pressed("mapod_full_win"):
		OS.set_window_fullscreen(!OS.window_fullscreen)

	if disable_input == false:
		if event.is_action_pressed("ui_accept"):
			print("BOUNCE")
			disable_input = true
			debouncer.start()
			_action(selected_node)

# ----- private methods

func _action(sel_node):
		if sel_node != null:
			var special = sel_node.get_special()
			var scene = sel_node.call_back()
			if special == BaseMapodMenuLabel.SPECIALCODES.NONE:
				if scene != null:
					emit_signal("scene_requested", scene)
			else:
				if special == BaseMapodMenuLabel.SPECIALCODES.EXIT:
					get_tree().quit()


func _on_selection_changed(name):
	var selected_node_name = "%s/%s" % [menu_name, name]
	var node = get_node_or_null(selected_node_name)
	if node != null and node is BaseMapodMenuLabel:
		selected_node = node


func _on_mouse_entered(which_node):
	print("enter %s" % which_node.get_name())
	mouse_current_node = which_node
	if label_style_mouse != null:
		which_node.set("custom_styles/normal", label_style_mouse)


func _on_mouse_exited(which_node):
	print("exit %s" % which_node.get_name())
	mouse_current_node = null
	if label_style_nomouse != null:
		which_node.set("custom_styles/normal", label_style_nomouse)

func _on_mouse_left_click_received():
	if disable_input == false:
		print("BOUNCE")
		disable_input = true
		debouncer.start()
		_action(mouse_current_node)

func _on_timeout():
	print("DEBOUNCE")
	disable_input = false

