extends Area2D
var inside = false

signal interacted
@export var npc_id := "alchemist"

func _ready() -> void:
	$Label.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		inside = true
		$Label.show()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		inside = false
		$Label.hide()

func is_interacted():
	if inside and Input.is_action_just_pressed("interact"):
		if Dialogue.current != Dialogue.state.waiting:
			return
		get_viewport().set_input_as_handled()
		interacted.emit()
		Events.npc_interacted.emit(npc_id)
