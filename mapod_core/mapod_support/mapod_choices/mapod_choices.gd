# tool

# class_name

# extends
extends Control

# # docstring


# ----- signals
signal scene_metaverse_requested()
signal set_panorama_requested(panorama)

# ----- enums
enum {
	NONE, TO_METAVERSE, CALL_EXIT, BACK, LOAD_PANORAMA
} 
# ----- constants

# ----- exported variables
export var extended: bool = false

# ----- public variables

# ----- private variables
var _operation = NONE
var _panorama_resource = null

# ----- onready variables
onready var to_metaverse_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ToMetaverse
onready var back_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Back
onready var exit_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Exit
onready var load_panorama_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/LoadPanorama
onready var dialogs = $Dialogs
onready var message_dialog = $Dialogs/MessageDialog
onready var confirm_dialog = $Dialogs/ConfirmDialog
onready var file_dialog = $Dialogs/FileDialog


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	confirm_dialog.connect("confirmed", self, "_on_confirm")
	confirm_dialog.connect("hide", self, "_on_hide_dialogs")

	file_dialog.connect("confirmed", self, "_on_confirm_file")
	file_dialog.connect("file_selected", self, "_on_confirm_file")
	file_dialog.connect("hide", self, "_on_hide_dialogs")
	file_dialog.clear_filters()
	#file_dialog.add_filter("*.png ; PNG Images")
	file_dialog.add_filter("*.jpg ; JPG Images")
	file_dialog.add_filter("*.jpeg ; JPEG Images")

	message_dialog.connect("confirmed", self, "_on_hide_dialogs")
	message_dialog.connect("hide", self, "_on_hide_dialogs")
	
	var _ret_val = to_metaverse_button.connect("pressed", self, "_on_to_metaverse")
	_ret_val = exit_button.connect("pressed", self, "_on_call_exit")
	_ret_val = back_button.connect("pressed", self, "_on_back")
	_ret_val = load_panorama_button.connect("pressed", self, "_on_load_panorama")
	
	if extended == true:
		force_extended()

# ----- remaining built-in virtual methods

# ----- public methods

func force_extended():
	load_panorama_button.visible = true

# ----- private methods

func _on_hide_dialogs():
	dialogs.visible = false
	confirm_dialog.visible = false


func _on_confirm_file(_path):
	_on_confirm()


func _on_confirm():
	_on_hide_dialogs()
	match _operation:
		TO_METAVERSE:
			emit_signal("scene_metaverse_requested")
		CALL_EXIT:
			get_tree().quit()
		BACK:
			var event = InputEventAction.new()
			event.action = "mapod_choices"
			event.pressed = true
			Input.parse_input_event(event)
		LOAD_PANORAMA:
			if _valid_panorama(file_dialog.current_path) == true:
				emit_signal("set_panorama_requested", _panorama_resource)
				_show_message("Panorama is loaded.")
			else:
				_show_message("Invalid panorama file !!!")
		NONE:
			pass


func _on_to_metaverse():
	dialogs.visible = true
	_operation = TO_METAVERSE
	confirm_dialog.dialog_text = "Vuoi tornare al metaverso ?"
	confirm_dialog.popup_centered()


func _on_call_exit():
	dialogs.visible = true
	_operation = CALL_EXIT
	confirm_dialog.dialog_text = "Vuoi uscire da MAPOD4D ?"
	confirm_dialog.popup_centered()


func _on_back():
	dialogs.visible = true
	_operation = BACK
	confirm_dialog.dialog_text = "Vuoi chiudere questo menu ?"
	confirm_dialog.popup_centered()


func _on_load_panorama():
	dialogs.visible = true
	_operation = LOAD_PANORAMA
	file_dialog.popup_centered()


func _show_message(message):
	dialogs.visible = true
	message_dialog.dialog_text = message
	message_dialog.popup_centered()


func _valid_panorama(file_name):
	var ret_val = true
	_panorama_resource = load_jpg(file_name)
	#_panorama_resource = ResourceLoader.load(file_name)
	#if _panorama_resource is StreamTexture:
	#	ret_val = true
	return ret_val


func load_jpg(file):
	var jpg_file = File.new()
	jpg_file.open(file, File.READ)
	var bytes = jpg_file.get_buffer(jpg_file.get_len())
	var img = Image.new()
	var data = img.load_jpg_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	jpg_file.close()
	return imgtex

func load_png(file):
	var png_file = File.new()
	png_file.open(file, File.READ)
	var bytes = png_file.get_buffer(png_file.get_len())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	png_file.close()
	return imgtex
