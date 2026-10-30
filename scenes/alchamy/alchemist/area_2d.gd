extends Area2D

signal interacted
signal in_
signal out_

@export var npc_id := "alchemist"
var inside := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		inside = true
		in_.emit()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		inside = false
		out_.emit()

func _unhandled_input(event: InputEvent) -> void:
	if inside and event.is_action_pressed("interact"):
		if Dialogue.current != Dialogue.state.waiting:
			return
		get_viewport().set_input_as_handled()
		interacted.emit()
		Events.npc_interacted.emit(npc_id)
