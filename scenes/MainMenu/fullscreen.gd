extends Button
func _on_pressed() -> void:
	var mode := DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_WINDOWED:
		text = "ON"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		text = "OFF"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
