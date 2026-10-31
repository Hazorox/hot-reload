extends StaticBody2D

@onready var area = $Area2D
@onready var collision = $CollisionShape2D
func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		if body.is_heavy:
			# Wait for 0.8 seconds, hide
			await get_tree().create_timer(0.8).timeout
			hide()
			collision.set_deferred("disabled",true)
			# Wait for 2 seconds, show back again
			await get_tree().create_timer(2).timeout
			show()
			collision.set_deferred("disabled",false)
