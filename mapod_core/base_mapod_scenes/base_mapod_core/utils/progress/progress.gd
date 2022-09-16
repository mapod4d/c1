extends Control


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables
onready var progress_bar = $ColorRect/VBoxContainer/MarginContainer/ProgressBar


# ----- public methods

func mapod_progress_value(value: float):
	progress_bar.value = value * 100
