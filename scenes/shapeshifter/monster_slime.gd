extends CharacterBody2D

@export_range(-1,1) var direction := -1
@export var speed := 80.0
@export var move_time := 3.0
@export var idle_time := 2.0
@export var health := 50.0
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D

var was_on_floor = false
var moving := true
var timer := 0.0
var last_safe_pos : Vector2
var is_dead := false
func _ready() -> void:
	last_safe_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_dead:
		velocity.x = 0.0
		if not is_on_floor():
			velocity+=get_gravity()*delta
		move_and_slide()
		return
	if is_on_floor():
		was_on_floor = true
		last_safe_pos = global_position
	else:
		if was_on_floor:
			_revert()
			return
		velocity += get_gravity() * delta
	timer += delta
	if moving and timer >= move_time:
		moving = false
		timer = 0.0
	elif not moving and timer>=idle_time:
		moving = true
		timer = 0.0
	
	if moving:
		sprite.play("move")
	else:
		sprite.play("idle")
	velocity.x = direction*speed if moving else 0.0
	move_and_slide()

func take_damage(amount=50):
	if is_dead:
		return
	health-=amount
	if health<=0:
		is_dead = true
		$HurtBox.set_deferred("monitorable",false)
		$bounce.set_deferred("monitorable",false)
		sprite.play("die")
		await sprite.animation_finished
		queue_free()

func _revert():
	global_position = last_safe_pos
	velocity = Vector2.ZERO
	was_on_floor = false
	direction *= -1
