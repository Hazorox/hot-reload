extends Button

func _on_pressed() -> void:
	Globals.switch_scene(preload("res://scenes/Main Menu/main.tscn"), 0.2)
