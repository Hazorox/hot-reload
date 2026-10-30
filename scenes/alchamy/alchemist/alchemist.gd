extends CharacterBody2D

@onready var label: Label = $Label
@onready var area: Area2D = $Area2D

func _ready() -> void:
	label.hide()
	area.in_.connect(inside)
	area.out_.connect(outside)

func inside():
	label.show()
	
func outside():
	label.hide()
