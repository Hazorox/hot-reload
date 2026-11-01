extends Area2D
signal reset

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(body,"position",Vector2(134,550),1.2)
		await tween.finished
		reset.emit()
