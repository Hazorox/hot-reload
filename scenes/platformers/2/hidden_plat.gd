extends "res://scripts/air_tile.gd"

func _ready() -> void:
	super()
	hide()
	collision.set_deferred("disabled",true)

func toggle(state:bool):
	visible = state
	collision.set_deferred("disabled",not state)
