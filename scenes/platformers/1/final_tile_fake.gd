extends StaticBody2D

@onready var collision:CollisionShape2D = $CollisionShape2D
@onready var detector:Area2D = $Area2D
@onready var real_tile:StaticBody2D = $"../final_tile_real"
func _ready() -> void:
	detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		real_tile.toggle_enabled(true)
		toggle_enabled(false)

func toggle_enabled(state:bool):
	visible = state
	collision.set_deferred("disabled",not state)
