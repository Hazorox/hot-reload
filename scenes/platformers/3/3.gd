extends Node2D

@export var next_scene:PackedScene = null

const monster_positions :Array[Vector2] = [Vector2(488,520)]
var new_monsters = []

func _ready() -> void:
	$end.done.connect(_on_done)
	$void.reset.connect(_on_reset)

func _on_done():
	get_tree().paused = true
	await get_tree().create_timer(1.5).timeout
	get_tree().paused = false
	Globals.switch_scene(next_scene,1.6)

func _on_reset():
	# wait for 0.8 seconds till player goes back in place
	await get_tree().create_timer(0.8).timeout
	var new_monsters = []
	for monster in get_tree().get_nodes_in_group("monster"):
		var new_monster = monster.duplicate()
		new_monsters.append(new_monster)
		monster.queue_free()
	for i in range(len(monster_positions)):
		var to_add_monster = new_monsters[i]
		to_add_monster.position = monster_positions[i]
		add_child(to_add_monster)
