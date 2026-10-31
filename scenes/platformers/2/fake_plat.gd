extends StaticBody2D
signal fake_touched(bool)
@onready var area:Area2D = $Area2D
@onready var collision :CollisionShape2D = $CollisionShape2D
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		visible = false
		collision.set_deferred("disabled",true)
		fake_touched.emit(true)
func _on_body_exited(body:Node2D):
	if body.is_in_group("player"):
		show()
		collision.set_deferred("disabled",false)
