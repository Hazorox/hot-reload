extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("Human")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_range(-1, 1) var dir: int = 1
@export var health : int = 50

var speed : float = 75.0
var gravity : float = 98.0
var is_dead : bool = false

func _ready() -> void:
	if dir == 0:
		dir = 1
	animated_sprite_2d.flip_h = false if dir == 1 else true

func _physics_process(delta: float) -> void:
	if is_dead:
		handling_death(delta)
		move_and_slide()
		return
	if health <= 0:
		is_dead = true
		animated_sprite_2d.play("dying")
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$BouncingArea/CollisionShape2D.set_deferred("disabled", true)
		return
	if dir == 1 and ($RightRay.is_colliding()):
		animated_sprite_2d.flip_h = true
		$Area2D.scale.x = -1
		$BouncingArea.scale.x = -1
		dir = -1
	elif dir == -1 and ($LeftRay.is_colliding()):
		animated_sprite_2d.flip_h = false
		$Area2D.scale.x = 1
		$BouncingArea.scale.x = 1
		dir = 1
		
	velocity.x = lerp(velocity.x, dir * speed, 10 * delta)
	move_and_slide()

func take_damage(amount = 50) -> void:
	health -= amount

func handling_death(delta: float) -> void:
	velocity.x = 0
	if not is_on_floor():
		velocity.y += gravity * delta
