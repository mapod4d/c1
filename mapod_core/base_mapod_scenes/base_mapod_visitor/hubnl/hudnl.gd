tool
extends Control


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
var input_enabled = false
var multiline_msg:PoolStringArray  = [
	"0 DB", 
	"1 DB",
	"2 DB",
	"3 DB",
	"4 DB",
	"5 DB"
]

# ----- private variables
var _speed_data = 0
var _altitude_data = 0

# ----- onready variables
onready var debug_msg = $GridContainer/DebugData/Debug


# ----- built-in virtual _ready method

func _ready():
	# Disable input
	enable_input(false)
	# Disable input of child
	enable_input_all_child(false, self)
#	for child in get_children():
#		enableInputAllchild(self)
#		child.mouse_filter = Control.MOUSE_FILTER_IGNORE
#		child.set_process_input(false)
#		child.set_process_unhandled_input(false)
#		child.set_process_unhandled_key_input(false)
	set_speed_data(0)
	set_altitude_data(0)
	set_info_data("")
	show_debug_msg()


# ----- remaining built-in virtual methods

# capture mouse when visible
func _input(event):
	if event is InputEventMouseButton:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			enable_input(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta):
	if Engine.editor_hint:
		_speed_data += 1
		if _speed_data > 999:
			_speed_data = 0
		set_speed_data(_speed_data)
		_altitude_data += 1
		if _altitude_data > 999:
			_altitude_data = 0
		set_altitude_data(_altitude_data)


# ----- public methods

# Abilita o disabilita l'input per tutti i child
func enable_input_all_child(flag:bool, node):
	for child in node.get_children():
		if child is Control:
			enable_node_input(flag, child)
		enable_input_all_child(flag, child)


# Abilita o disabilita l'input per il nodo corrente
func enable_input(flag:bool):
	input_enabled = flag
	enable_node_input(flag, self)


# Disable or enable input for a node
func enable_node_input(flag:bool, node:Control):
	if flag:
		node.mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.set_process_input(flag)
	node.set_process_unhandled_input(flag)
	node.set_process_unhandled_key_input(flag)


func set_debug(flag: bool):
	debug_msg.visible = flag


func show_debug_msg():
	if debug_msg:
		debug_msg.text = multiline_msg.join("\n")


func print_debug_msg(msg: String, index:int):
	if index < multiline_msg.size():
		multiline_msg[index] = "{index} DB {msg}".format({
			"index": index,
			"msg": msg,
		})
		show_debug_msg()


func set_altitude_data(value: int):
	var altitude_data = get_node_or_null("GridContainer/MarginContainer/VBoxContainer/AltitudeData/Container/Value")
	if altitude_data != null:
		altitude_data.text = "%d" % value


func set_speed_data(value: int):
	var speed_data = get_node_or_null("GridContainer/MarginContainer/VBoxContainer/SpeedData/Container/Value")
	if speed_data != null:
		speed_data.text = "%d" % value


func set_info_data(value: String):
	var info_data = get_node_or_null("GridContainer/MarginContainer/VBoxContainer/InfoData/Container/Value")
	if info_data != null:
		info_data.text = value

func set_e_info_data(value: String):
	var e_info_data = get_node_or_null("GridContainer/MarginContainer/VBoxContainer/AnalysableAdvise/Container/Info")
	if e_info_data != null:
		e_info_data.text = value

func set_first_interaction_info(value: String):
	var e_info_data = get_node_or_null("GridContainer/MarginContainer/VBoxContainer/AnalysableAdvise/Container/Info")
	if e_info_data != null:
		e_info_data.text = value

func set_second_interaction_info(value: String):
	var r_info_data = get_node_or_null("GridContainer/MarginContainer/VBoxContainer/AnalysableAdviseExt/Container/Info")
	if r_info_data != null:
		r_info_data.text = value

func set_show_analysable(flag_advise: bool, flag_advise_ext: bool):
	var local_advise = get_node_or_null("GridContainer/MarginContainer/VBoxContainer/AnalysableAdvise")
	var local_advise_ext = get_node_or_null("GridContainer/MarginContainer/VBoxContainer/AnalysableAdviseExt")

	if local_advise != null:
		if flag_advise:
			local_advise.visible = true
		else:
			local_advise.visible = false

	if local_advise_ext != null:
		if flag_advise_ext:
			local_advise_ext.visible = true
		else:
			local_advise_ext.visible = false

