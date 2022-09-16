# tool

# class_name

# extends
extends Control

# # docstring


# ----- signals
signal scene_metaverse_requested()

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables
onready var to_metaverse_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ToMetaverse
onready var back_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Back
onready var exit_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Exit
onready var confirm_exit = $ConfirmExit
onready var confirm_to_metaverse = $ConfirmToMetaverse


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	to_metaverse_button.connect("pressed", self, "_on_to_metaverse")
	to_metaverse_button.connect("pressed", self, "_on_to_metaverse_confirm")
	back_button.connect("pressed", self, "_on_back")
	exit_button.connect("pressed", self, "_on_exit_confirm")
	confirm_to_metaverse.connect("yes_pressed", self, "_on_to_metaverse")
	confirm_exit.connect("yes_pressed", self, "_on_exit")

# ----- remaining built-in virtual methods

# ----- public methods

# ----- private methods

func _on_back():
	var event = InputEventAction.new()
	event.action = "mapod_choices"
	event.pressed = true
	Input.parse_input_event(event)


func _on_to_metaverse_confirm():
	confirm_to_metaverse.popup_centered()


func _on_to_metaverse():
	emit_signal("scene_metaverse_requested")


func _on_exit_confirm():
	confirm_exit.popup_centered()


func _on_exit():
	get_tree().quit()
