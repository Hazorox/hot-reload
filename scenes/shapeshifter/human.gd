extends CharacterBody2D

const PLAYER = preload("uid://btyvb3odq453")
const PLAYER_WITH_STICK = preload("uid://b4a77y88btrlt")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $SideAttack/CollisionShape2D
@onready var side_attack_area: Area2D = $SideAttack
@onready var DoubleJump: Area2D = $DoubleJump
@onready var double_jump_shape: CollisionShape2D = $DoubleJump/CollisionShape2D

@export var player_has_stick : bool = false
@export var is_heavy:bool = false
var speed : float = 0.0
var speed_rate := 500
var jump_force : int = 700 # I changed init value Vii added
var heading : Vector2
var player_state : String
var gravity : float = 980
var is_player_attacking : bool = false
var is_bouncing_h : bool = false
var bounce_timer : float = 0.0

func _ready() -> void:
	add_to_group("player")

func _process(delta: float) -> void:
	handle_player_items()
	var direction := Input.get_vector("left", "right", "null", "null")
	if is_bouncing_h:
		bounce_timer -= delta
		if bounce_timer <= 0:
			is_bouncing_h = false
	else:
		if not is_player_attacking:
			collision_shape_2d.disabled = true
			movement_speed_modifier(delta)
		else:
			speed = 0
			collision_shape_2d.disabled = false
		velocity.x = direction.x * speed
	if not is_player_attacking:
		handling_player_jump(delta)
	flip_animation()
	set_animations()
	print(player_state)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_released_by_event("right", event):
		print("right_is_released")
		speed = 0
	if Input.is_action_just_released_by_event("left", event):
		print("left_is_released")
		speed = 0

func is_direction_pressed() -> bool:
	if Input.is_action_pressed("right"):
		heading = Vector2.RIGHT
		return true
	elif Input.is_action_pressed("left"):
		heading = Vector2.LEFT
		return true
	else:
		return false

func movement_speed_modifier(delta: float) -> void:
	if is_direction_pressed():
		if Input.is_action_pressed("dashing"):
			if speed <= 750:
				speed += speed_rate * delta
			if is_on_floor():
				player_state = "player_running"
		else:
			if speed <= 300.0:
				speed += speed_rate * delta
			if is_on_floor():
				player_state = "player_walking"
	else:
		speed = 0
		if is_on_floor() and not is_player_attacking:
			player_state = "player_idle"

func handling_player_jump(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_force
		else:
			var damaged_monster = false
			for area in DoubleJump.get_overlapping_areas():
				if area.is_in_group("monster"):
					damaged_monster = true
					if area.owner and area.owner.has_method("take_damage"):
						area.owner.take_damage()
					break
			if damaged_monster:
				velocity.y = -jump_force * 1

	# --- Jump Cut Mechanism ---
	# If the player releases the jump button while still moving upwards, cut their upward velocity
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5 # Adjust 0.5 (e.g., 0.3 to 0.6) to change how quickly the jump cuts

func flip_animation() -> void:
	if heading == Vector2.RIGHT:
		sprite_2d.flip_h = true
		side_attack_area.scale.x = -1
	if heading == Vector2.LEFT:
		sprite_2d.flip_h = false
		side_attack_area.scale.x = 1

func set_player_state() -> void:
	if Input.is_action_just_pressed("attack") and player_has_stick and is_on_floor():
		is_player_attacking = true
		player_state = "player_attacking"
	elif not is_on_floor():
		if velocity.y < 0:
			player_state = "player_jumping"
		elif velocity.y > 0:
			player_state = "player_falling"

func set_animations() -> void:
	set_player_state()
	if player_state == "player_running":
		animation_player.play("running")
	elif player_state == "player_walking":
		animation_player.play("walking")
	elif player_state == "player_jumping":
		animation_player.play("jumping")
	elif player_state == "player_falling":
		animation_player.play("falling")
	elif player_state == "player_attacking":
		animation_player.play("attacking")
	else:
		animation_player.play("idle")

func handle_player_items() -> void:
	if not player_has_stick:
		sprite_2d.texture = PLAYER
	else:
		sprite_2d.texture = PLAYER_WITH_STICK

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attacking":
		is_player_attacking = false
		player_state = "player_idle"

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bouncing"):
		var bounce_direction = sign(global_position.x - area.global_position.x)
		if bounce_direction == 0:
			bounce_direction = 1
		velocity.x = bounce_direction * 500.0
		is_bouncing_h = true
		bounce_timer = 0.2
