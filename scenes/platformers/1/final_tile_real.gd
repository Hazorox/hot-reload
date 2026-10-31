extends StaticBody2D

@onready var to_enable:Array[CollisionShape2D] = [$CollisionShape2D,$CollisionShape2D2,$trap2/CollisionShape2D]
@onready var trap:Area2D = $trap2

func _ready() -> void:
	trap.reset.connect(_on_trap_reset)

func toggle_enabled(to:bool):
	if to:
		show()
		for collision in to_enable:
			collision.set_deferred("disabled",false)
	else:
		hide()
		for collision in to_enable:
			collision.set_deferred("disabled",true)

func _on_trap_reset():
	toggle_enabled(false)
