extends Area2D
signal reset
func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(body,"position:y",540,0.8)
		tween.tween_property(body,"position:x",80,0.8)
		reset.emit()
