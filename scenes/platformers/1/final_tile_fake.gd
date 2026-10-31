extends StaticBody2D

@onready var detector:Area2D = $Area2D
@onready var real_tile:StaticBody2D = $"../final_tile_real"
func _ready() -> void:
	detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		real_tile.toggle_enabled(true)
		queue_free()
