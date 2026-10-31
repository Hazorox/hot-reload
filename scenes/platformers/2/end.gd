extends Area2D
signal done

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		done.emit()
