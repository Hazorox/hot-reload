extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("Human")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_range(-1, 1) var dir: int = 1

var speed : float = 35.0

func _ready() -> void:
	if dir == 0:
		dir = 1
	animated_sprite_2d.flip_h = false if dir == 1 else true

func _physics_process(delta: float) -> void:
	if dir == 1 and ($RightRay.is_colliding()):
		animated_sprite_2d.flip_h = true
		dir = -1
	if dir == -1 and ($LeftRay.is_colliding()):
		animated_sprite_2d.flip_h = false
		dir = 1
	velocity.x = lerp(velocity.x, dir * speed, 10 * delta)
	move_and_slide()
