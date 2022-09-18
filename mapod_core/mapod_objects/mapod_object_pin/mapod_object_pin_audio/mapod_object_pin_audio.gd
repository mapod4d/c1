# tool

# class_name
class_name MapodObjectPinAudio

# extends
extends MapodObjectPin

# # docstring


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables
export(AudioStream) var first_sound;

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

func _ready():
	pass

# ----- remaining built-in virtual methods

# ----- public methods

func do_first_interaction():
	if first_sound != null:
		$AudioStreamPlayer3D.stream = first_sound
		$AudioStreamPlayer3D.play()

func do_second_interaction():
	if first_sound != null:
		$AudioStreamPlayer3D.stop()

# ----- private methods
