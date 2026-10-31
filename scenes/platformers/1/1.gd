extends Node2D
@export var next_scene:PackedScene = null
@onready var end = $end

func _ready():
	end.reached.connect(_on_reached)

func _on_reached():
	Globals.switch_scene(next_scene)
