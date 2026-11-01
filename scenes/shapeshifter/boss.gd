extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var hurt_box : Area2D = $HurtBox
@onready var hitting_box: Area2D = $HittingBox
@onready var collision_shape_2d: CollisionShape2D = $HittingBox/CollisionShape2D

@export var health : int = 500
@export var speed : float = 180.0
@export var slide_speed : float = 850.0
@export var attack_range : float = 65.0
@export var chance_slide_after_attack : float = 0.6
@export var chance_combo_attack : float = 0.25
@export var slide_duration_min : float = 0.3
@export var slide_duration_max : float = 0.5
@export var attack_windup_time : float = 0.3
@export var alchemist_scene_path : String = "res://scenes/alchamy/main/main.tscn"

var player : Node2D = null
var gravity : float = 980.0
var is_dead : bool = false
var is_sliding : bool = false
var is_attacking : bool = false
var is_preparing_attack : bool = false
var attack_windup_timer : float = 0.0
var slide_direction : int = 1
var slide_timer : float = 0.0

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	check_player_attack()
	if is_dead:
		play_animation("death")
		velocity.x = 0
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		return
	if health <= 0:
		is_dead = true
		is_attacking = false
		is_preparing_attack = false
		play_animation("death")
		velocity.x = 0
		move_and_slide()
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_sliding:
		velocity.x = slide_direction * slide_speed
		slide_timer -= delta
		play_animation("sliding")
		if slide_timer <= 0:
			is_sliding = false
	elif is_preparing_attack:
		velocity.x = 0
		attack_windup_timer -= delta
		play_animation("idle")
		if attack_windup_timer <= 0:
			is_preparing_attack = false
			if player and abs(player.global_position.x - global_position.x) <= attack_range:
				is_attacking = true
				play_animation("attacking")
	elif is_attacking:
		velocity.x = 0
	elif player:
		var distance_x = player.global_position.x - global_position.x
		if abs(distance_x) <= attack_range:
			velocity.x = 0
			is_preparing_attack = true
			attack_windup_timer = attack_windup_time
			if distance_x > 0:
				sprite_2d.flip_h = true
				hurt_box.scale.x = -1
				hitting_box.scale.x = -1
			else:
				sprite_2d.flip_h = false
				hurt_box.scale.x = 1
				hitting_box.scale.x = 1
		elif abs(distance_x) > 10.0:
			var direction_to_player = sign(distance_x)
			velocity.x = direction_to_player * speed
			if direction_to_player > 0:
				sprite_2d.flip_h = true
				hurt_box.scale.x = -1
				hitting_box.scale.x = -1
			else:
				sprite_2d.flip_h = false
				hurt_box.scale.x = 1
				hitting_box.scale.x = 1
			play_animation("walking")
		else:
			velocity.x = 0
			play_animation("idle")
	else:
		velocity.x = 0
		play_animation("idle")
	move_and_slide()

func play_animation(anim_name : String) -> void:
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)

func take_damage(amount = 25) -> void:
	if is_dead or is_sliding:
		return
	health -= amount

func trigger_slide_behind_player() -> void:
	is_sliding = true
	is_attacking = false
	slide_timer = randf_range(slide_duration_min, slide_duration_max)
	if player.global_position.x > global_position.x:
		slide_direction = 1
		sprite_2d.flip_h = true
		hurt_box.scale.x = -1
		hitting_box.scale.x = -1
	else:
		slide_direction = -1
		sprite_2d.flip_h = false
		hurt_box.scale.x = 1
		hitting_box.scale.x = 1
	play_animation("sliding")

func check_player_attack() -> void:
	if is_attacking:
		collision_shape_2d.disabled = false
	else:
		collision_shape_2d.disabled = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attacking":
		is_attacking = false
		if is_dead or not player:
			return
		var roll = randf()
		if roll < chance_slide_after_attack:
			trigger_slide_behind_player()
		elif roll < chance_slide_after_attack + chance_combo_attack:
			var distance_x = player.global_position.x - global_position.x
			if abs(distance_x) <= attack_range:
				is_preparing_attack = true
				attack_windup_timer = attack_windup_time
	elif anim_name == "death":
		Globals.switch_scene(load(alchemist_scene_path), 0.67)

func _on_hitting_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		ViiGlobals.player_health -= 10

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		take_damage()
