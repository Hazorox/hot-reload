extends Node

var history: Array[String] = []

func go_back() -> void:
	if history.is_empty():
		return
	var path: String = history.pop_back()
	get_tree().change_scene_to_file(path)

func switch_scene(scene:PackedScene,duration:float):
		# add layer and rect to dim screen
		var layer := CanvasLayer.new()
		layer.layer = 67
		var rect := ColorRect.new()
		rect.color = Color.BLACK
		rect.modulate.a = 0.0
		rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		layer.add_child(rect)
		get_tree().root.add_child(layer)
		
		var current := get_tree().current_scene
		if current and current.scene_file_path != "":
			history.push_back(current.scene_file_path)
		
		
		var fade_out := create_tween().tween_property(rect,"modulate:a",1.0,duration/2.0)
		await fade_out.finished
		get_tree().change_scene_to_packed(scene)
		
		# Idk what that does tbh, Claude helped me coz I had some bugs here
		await get_tree().process_frame
		await get_tree().process_frame
		
		var fade_in := create_tween().tween_property(rect,"modulate:a",0.0,duration/2.0)
		await fade_in.finished
		layer.queue_free()
