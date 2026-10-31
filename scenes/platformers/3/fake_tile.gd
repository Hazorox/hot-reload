extends StaticBody2D

@onready var area:Area2D = $Area2D
@onready var collision:CollisionShape2D = $CollisionShape2D

func _ready():
	# Listen
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body:Node2D):
	# Hide and disable collision
	if body.is_in_group("player"):
		hide()
		collision.set_deferred("disabled",true)

func _on_body_exited(body:Node2D):
	# Show and re-enable collision
	if body.is_in_group("player"):
		show()
		collision.set_deferred("disabled",false)
