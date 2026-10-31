extends Area2D

@export var deadly := true
var inside := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_visible_in_tree():
		inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		inside = false

func _unhandled_input(event: InputEvent) -> void:
	if not deadly or not inside or not is_visible_in_tree():
		return
	if event.is_action_pressed("interact"):
		if Dialogue.current != Dialogue.state.waiting:
			return
		get_viewport().set_input_as_handled()
		Events.death_leaf.emit()

func enable(on: bool) -> void:
	visible = on
	set_deferred("monitoring", on)
	if not on:
		inside = false
