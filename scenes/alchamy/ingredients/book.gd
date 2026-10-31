extends CharacterBody2D

@onready var area: Area2D = $Area2D

func _ready() -> void:
	area.body_entered.connect(on_entered)

func on_entered(body: Node2D) -> void:
	if not visible:
		return
	if body.is_in_group("player"):
		Events.book_found.emit()
		enable(false)

func enable(on: bool) -> void:
	visible = on
	area.set_deferred("monitoring", on)
