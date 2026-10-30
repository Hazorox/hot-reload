extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var speed : float = 0.0
var speed_rate := 500
var jump_force : int = 250
var heading : Vector2
var player_state : String

func _ready() -> void:
	add_to_group("player")

func _process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "null", "null")
	movement_speed_modifier(delta)
	velocity = speed * direction
	flip_animation()
	set_animations()
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
	if is_direction_pressed() and Input.is_action_pressed("dashing"):
		if speed <= 750:
			player_state = "player_running"
			speed += speed_rate * delta
	elif is_direction_pressed():
		if speed <= 500.0:
			player_state = "player_walking"
			speed += speed_rate * delta
	else:
		speed = 0
		player_state = "player_idle"

func flip_animation() -> void:
	if heading == Vector2.RIGHT:
		sprite_2d.flip_h = true
	if heading == Vector2.LEFT:
		sprite_2d.flip_h = false

func set_animations() -> void:
	if player_state == "player_running":
		animation_player.play("running")
	elif player_state == "player_walking":
		animation_player.play("walking")
	else:
		animation_player.play("idle")
