extends Button
var bus = AudioServer.get_bus_index("Master")

func _ready() -> void:
	var muted = AudioServer.is_bus_mute(bus)
	if muted:
		text = "OFF"
	else:
		text = "ON"

func _on_pressed() -> void:
	var muted = not AudioServer.is_bus_mute(bus)
	AudioServer.set_bus_mute(bus, muted)
	if muted:
		text = "OFF"
	else:
		text = "ON"
