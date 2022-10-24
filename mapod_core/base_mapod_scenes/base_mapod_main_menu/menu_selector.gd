extends Sprite


# ----- signals
signal selection_changed(name)

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
var margin_x = 2
var selections_names = []
var selections_positions = []
var selected = 0

# ----- private variables

# ----- onready variables


# ----- remaining built-in virtual methods

func _input(event):
	var current_selected = selected
	if event.is_action_pressed("mapod_menu_up"):
		current_selected -= 1
	if event.is_action_pressed("mapod_menu_down"):
		current_selected += 1
	set_selection(current_selected)

# ----- public methods

func set_selection(value: int):
	var len_selections = len(selections_positions)
	if len_selections > 0:
		if value >= len_selections:
			value = 0
		if value < 0:
			value = len_selections - 1
		position = selections_positions[value]
		selected = value
		emit_signal("selection_changed", selections_names[selected])


