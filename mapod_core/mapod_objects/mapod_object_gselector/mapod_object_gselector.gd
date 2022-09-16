# tool

# class_name

# extends
extends BaseMapodObject

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(PoolStringArray) var group_list
export(int) var start_group = 0

# ----- public variables

# ----- private variables

var _group_list_len = 0
var _valid_mo = false
var _current_group = 0

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	_valid_mo = false
	_current_group = 0
	_group_list_len = group_list.size()
	if _group_list_len > 0:
		if start_group <=  _group_list_len:
			_current_group = start_group
			_valid_mo = true
			_elab()

# ----- remaining built-in virtual methods

# ----- public methods

func do_first_interaction():
	if _current_group > 0:
		_current_group = _current_group - 1
		_elab()


func do_second_interaction():
	if _group_list_len > 0:
		if _current_group < _group_list_len - 1:
			_current_group = _current_group + 1
			_elab()

# ----- private methods

func _elab():
	var current = 0
	var show_group = ""
	for group_sel in group_list:
		if current == _current_group:
			show_group = group_sel
		else:
			get_tree().call_group(group_sel, "hide")
		current = current + 1
	if show_group != "":
		get_tree().call_group(show_group, "show")

