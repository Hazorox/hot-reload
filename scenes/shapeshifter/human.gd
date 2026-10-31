extends CharacterBody2D

const PLAYER = preload("uid://btyvb3odq453")
const PLAYER_WITH_STICK = preload("uid://b4a77y88btrlt")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var player_has_stick : bool = false

var speed : float = 0.0
var speed_rate := 500
var jump_force : int = 450
var heading : Vector2
var player_state : String
var gravity : float = 980
var is_player_attacking : bool = false

func _ready() -> void:
	add_to_group("player")

func _process(delta: float) -> void:
	handle_player_items()
	var direction := Input.get_vector("left", "right", "null", "null")
	
	# 1. Stop movement/state updates from interrupting attacks
	if not is_player_attacking:
		movement_speed_modifier(delta)
		handling_player_jump(delta)
	else:
		velocity.x = 0 # Optional: Stops sliding while attacking
		
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
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

func flip_animation() -> void:
	if heading == Vector2.RIGHT:
		sprite_2d.flip_h = true
	if heading == Vector2.LEFT:
		sprite_2d.flip_h = false

func set_player_state() -> void:
	# 2. Corrected operators and logic conditions
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
		animation_player.play("attacking") # Keeps playing "attacking"
	else:
		animation_player.play("idle")

func handle_player_items() -> void:
	if not player_has_stick:
		sprite_2d.texture = PLAYER
	else:
		sprite_2d.texture = PLAYER_WITH_STICK

# 3. Fixed string mismatch here ("attacking" instead of "attack")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attacking":
		is_player_attacking = false
		player_state = "player_idle"
