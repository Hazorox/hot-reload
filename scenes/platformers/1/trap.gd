extends Area2D


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# animate players motion to 79,531
		var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR).set_parallel(true)
		tween.tween_property(body,"position:y",531,0.6)
		tween.tween_property(body,"position:x",79,0.6)
