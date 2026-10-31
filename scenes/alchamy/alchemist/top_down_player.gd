extends CharacterBody2D

@export var animation_player: AnimationPlayer
@onready var top_down_player: CharacterBody2D = $"."

enum State{
	IDLE,
	WALKING,
	ATTACKING,
}

var speed : int = 5000
var heading : Vector2 = Vector2.DOWN
var state := State.IDLE

func _process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed * delta
	move_and_slide()
	set_heading()
	flip_sprites()
	var is_attacking = animation_player.is_playing() and animation_player.current_animation.begins_with("attack")
	if is_player_attacking() and not is_attacking:
		set_hitting_animation()
	elif not is_attacking:
		if is_player_walking():
			set_walking_animation()
		else:
			set_idle_animation()

func is_player_walking() -> bool:
	if top_down_player.velocity != Vector2.ZERO:
		return true
	else:
		return false

func is_player_attacking() -> bool:
	if Input.is_action_just_pressed("attack"):
		return true
	else:
		return false

func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT
	elif velocity.y > 0:
		heading = Vector2.DOWN
	elif velocity.y < 0:
		heading = Vector2.UP

func set_idle_animation() -> void:
	if velocity.length() == 0 and heading == Vector2.UP:
		animation_player.play("idle_back")
	elif velocity.length() == 0 and heading == Vector2.DOWN:
		animation_player.play("idle_front")
	elif velocity.length() == 0 and heading == Vector2.LEFT:
		animation_player.play("idle_side")
	elif velocity.length() == 0 and heading == Vector2.RIGHT:
		animation_player.play("idle_side")

func set_walking_animation() -> void:
	if velocity.length() > 0 and heading == Vector2.UP:
		animation_player.play("walk_back")
	elif velocity.length() > 0 and heading == Vector2.DOWN:
		animation_player.play("walk_front")
	elif velocity.length() > 0 and heading == Vector2.LEFT:
		animation_player.play("walk_side")
	elif velocity.length() > 0 and heading == Vector2.RIGHT:
		animation_player.play("walk_side")

func set_hitting_animation() -> void:
	if Input.is_action_just_pressed("attack") and heading == Vector2.UP:
		animation_player.play("attack_back")
	elif Input.is_action_just_pressed("attack") and heading == Vector2.DOWN:
		animation_player.play("attack_front")
	elif Input.is_action_just_pressed("attack") and heading == Vector2.RIGHT:
		animation_player.play("attack_side")
	elif Input.is_action_just_pressed("attack") and heading == Vector2.LEFT:
		animation_player.play("attack_side")

func flip_sprites() -> void:
	if heading == Vector2.RIGHT:
		$PlayerSprite.flip_h = false
	elif heading == Vector2.LEFT:
		$PlayerSprite.flip_h = true
