# tool
tool

# class_name

# extends
extends Spatial

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(String) var info = "testo di prova"
export(Color, RGBA) var color = Color(0.39, 1, 0.39, 1)
export(bool) var animated_flag = false
export(float) var show_time_delay = 0.1
export(int) var pause_cicles = 10
export(Color, RGBA) var color_path = Color(1, 1, 1, 1)
export(String) var info_path = "Percorso di STUDIO"
export(bool) var path_visible_flag = false

# ----- public variables

# ----- private variables
var _timer = null
var _current_cicle = 0
var _p_visible = 1

# ----- onready variables
onready var info_panel_label = $Panel/Viewport/Label
onready var path_type_panel = $PathTypePanel
onready var path_type_panel_label = $PathTypePanel/Viewport/Label


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	_internal_ready()

# ----- remaining built-in virtual methods

func _process(delta):
	_internal_data()
	_set_visible_perc()


# ----- public methods

# ----- private methods

func _internal_ready():
	_internal_data()
	if animated_flag == true:
		_p_visible = 0
		_set_visible_perc()
		_timer = Timer.new()
		_timer.set_wait_time(show_time_delay)
		_timer.connect("timeout", self, "_on_timeout")
		add_child(_timer)
		_timer.start()
	else:
		_p_visible = 1
		_set_visible_perc()

func _internal_data():
	if Engine.editor_hint:
		info_panel_label = get_node_or_null("Panel/Viewport/Label")
		path_type_panel = get_node_or_null("PathTypePanel")
		path_type_panel_label = get_node_or_null("PathTypePanel/Viewport/Label")

	if info_panel_label != null:
		info_panel_label.text = info
		info_panel_label.set("custom_colors/font_color", color)
	if path_type_panel != null and path_type_panel_label != null:
		path_type_panel.visible = path_visible_flag
		path_type_panel_label.visible = path_visible_flag
		if path_visible_flag:
			path_type_panel_label.text = info_path
			path_type_panel_label.set("custom_colors/font_color", color_path)

func _on_timeout():
	_inc_visible()


func _inc_visible():
	if _p_visible < 1:
		_p_visible = _p_visible + 0.1
	if _p_visible > 1:
		_p_visible = 1
	if _p_visible == 1:
		_current_cicle = _current_cicle + 1
		if _current_cicle == pause_cicles:
			_current_cicle = 0
			_p_visible = 0


func _set_visible_perc():
	$Panel/Viewport/Label.percent_visible = _p_visible

