extends Node2D

@export var next_scene:PackedScene = null

@onready var settings: CanvasLayer = $CanvasLayer
@onready var settings_node: Control = $CanvasLayer/Settings
@onready var void_area:Area2D = $void
@onready var bat_scene:PackedScene = preload("res://scenes/shapeshifter/monester_bat.tscn")
@onready var fake_plat:StaticBody2D = $fake_plat
@onready var real_plat:StaticBody2D = $hidden_plat
@onready var end_statue:Area2D = $end
const bat_positions :Array[Vector2] = [Vector2(675,500),Vector2(1300,436),Vector2(1600,436),Vector2(2400,436)]

func _ready():
	settings.visible = false
	end_statue.done.connect(_on_done)
	fake_plat.fake_touched.connect(_fake_plat_touched)
	void_area.reset.connect(_on_reset)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = true
		settings.visible = true
		settings_node.visible = true

func _on_done():
	get_tree().paused = true
	await get_tree().create_timer(1.5).timeout
	get_tree().paused=false
	Globals.switch_scene(next_scene,1.4)

func _on_reset():
	real_plat.toggle(false)
	for monster in get_tree().get_nodes_in_group("monster"):
		monster.queue_free()
	for bat in bat_positions:
		var bat_new = bat_scene.instantiate()
		bat_new.dir = [1,-1].pick_random()
		bat_new.scale = Vector2(2.5,2.5)
		bat_new.position = bat
		add_child(bat_new)

func _fake_plat_touched(state:bool):
	real_plat.toggle(state)
