extends Button
# registering previous value and main action name
var action:StringName
var previous_text := ""

# Listening for pressed, and disabling input
func _ready():
	action = name
	pressed.connect(_listen)
	set_process_input(false)

# Setting text to ? and activate input
func _listen():
	for e in InputMap.action_get_events(action):
		if e is InputEventKey:
			text = e.as_text()
	previous_text = text
	text = "?"
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		get_viewport().set_input_as_handled() # Set input handled and cancel
		return
	# rebind action to new input, and disable input
	if event is InputEventKey and event.pressed and not event.echo:
		get_viewport().set_input_as_handled()
		if event.keycode == KEY_ESCAPE:
			text = previous_text.trim_suffix(" - Physical") # Cancel input
		else:
			_rebind(event)
		set_process_input(false)

func _rebind(event:InputEventKey):
	# Check if already taken
	if _check_key_taken(event):
		text = previous_text.trim_suffix(" - Physical")
		return
	# Erase old key, register new
	for e in InputMap.action_get_events(action):
		if e is InputEventKey:
			InputMap.action_erase_event(action,e)
	var new_event := InputEventKey.new()
	new_event.physical_keycode = event.physical_keycode
	InputMap.action_add_event(action,new_event)
	text = new_event.as_text().trim_suffix(" - Physical")

func _check_key_taken(event:InputEventKey)->bool:
	# Check for overlaps, with ignoring main action and ui_ actions
	for other in InputMap.get_actions():
		if other == action or other.begins_with("ui_"):
			continue
		for e in InputMap.action_get_events(other):
			if e is InputEventKey and e.physical_keycode == event.physical_keycode:
				return true
	return false
