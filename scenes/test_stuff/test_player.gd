extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

@onready var attack_area = $attack
@onready var attack_collisoin = $attack/CollisionShape2D
# Jump cut for increasing jump based on how much up was held
const jump_cut = 0.25
const attack_down = Vector2(0,30)
const attack_up = Vector2(0,-30)
const attack_left = Vector2(-30,0)
const attack_right = Vector2(30,0)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("up") and velocity.y < 0:
		velocity.y *= jump_cut
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
