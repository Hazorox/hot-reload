extends StaticBody2D

@onready var area:Area2D = $Area2D
func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		queue_free()
