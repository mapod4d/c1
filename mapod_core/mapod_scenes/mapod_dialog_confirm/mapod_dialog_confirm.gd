# tool
tool

# class_name

# extends
extends WindowDialog

# # docstring


# ----- signals
signal yes_pressed()

# ----- enums

# ----- constants

# ----- exported variables
export(String, MULTILINE) var message_text = "none"
# ----- public variables

# ----- private variables

# ----- onready variables
onready var yes = $MarginContainer/VBoxContainer/HBoxContainer/Si
onready var no = $MarginContainer/VBoxContainer/HBoxContainer/No
onready var message = $MarginContainer/VBoxContainer/Label

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	yes.connect("pressed", self, "_on_yes_pressed")
	no.connect("pressed", self, "_on_no_pressed")
	mapod_set_message(message_text)

# ----- remaining built-in virtual methods

func _process(_delta):
	if Engine.editor_hint:
		mapod_set_message(message_text)

# ----- public methods

func mapod_popup():
	popup_centered()


func mapod_set_message(text: String):
	if message != null:
		message.text = text

# ----- private methods

func _on_yes_pressed():
	emit_signal("yes_pressed")


func _on_no_pressed():
	visible = false
