extends Node2D

@onready var settings: CanvasLayer = $CanvasLayer
@onready var settings_node: Control = $CanvasLayer/Settings

func _ready() -> void:
	settings.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = true
		settings.visible = true
		settings_node.visible = true
