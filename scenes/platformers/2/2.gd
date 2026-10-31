extends Node2D
@onready var void_area:Area2D = $void
@onready var bat_scene:PackedScene = preload("res://scenes/shapeshifter/monester_bat.tscn")
const bat_positions :Array[Vector2] = [Vector2(675,413)]

func _ready():
	void_area.reset.connect(_on_reset)

func _on_reset():
	for monster in get_tree().get_nodes_in_group("monster"):
		monster.queue_free()
	for bat in bat_positions:
		var bat_new = bat_scene.instantiate()
		bat_new.scale = Vector2(2.5,2.5)
		bat_new.position = bat
		add_child(bat_new)
