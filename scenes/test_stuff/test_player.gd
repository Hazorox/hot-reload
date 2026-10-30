extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

@onready var attack_area = $attack
@onready var attack_collision = $attack/CollisionShape2D
# Jump cut for increasing jump based on how much up was held
const jump_cut = 0.25
const attack_down = Vector2(0,30)
const attack_up = Vector2(0,-30)
const attack_left = Vector2(-30,0)
const attack_right = Vector2(30,0)
const attack_dur = 0.2
var facing := 1

func _ready():
	attack_collision.disabled = true
@export var attacking := false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		facing = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("attack") and not attacking:
		attack(get_offset())
	move_and_slide()
func attack(offset:Vector2):
	attacking = true
	attack_area.position = offset
	attack_area.rotation = offset.angle()
	attack_collision.set_deferred("disabled",false)
	await get_tree().create_timer(attack_dur).timeout
	attack_collision.set_deferred("disabled",true)
	attacking = false

func get_offset()->Vector2:
	if Input.is_action_pressed("up"):
		return attack_up
	if Input.is_action_pressed("down") and not is_on_floor():
		return attack_down
	if Input.is_action_pressed("left"):
		return attack_left
	if Input.is_action_pressed("right"):
		return attack_right
	return attack_right if facing >0 else attack_left
