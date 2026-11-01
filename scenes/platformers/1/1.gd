extends Node2D

@export var next_scene:PackedScene = null

@onready var end = $end
@onready var settings: Control = $Settings

func _ready():
	settings.visible = false
	end.reached.connect(_on_reached)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = true
		settings.visible = true

func _on_reached():
	Globals.switch_scene(next_scene,1.6)
