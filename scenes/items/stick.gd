extends Area2D
@onready var key:TextureRect = $key
@export var interactable:=false
var player = null
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	set_key_shown(false)
	
	var original_y := key.position.y
	var tween := key.create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(key, "position:y", original_y + 20.0, 0.5)
	tween.tween_property(key, "position:y", original_y, 0.5)

func _process(_delta:float):
	if Input.is_action_just_pressed("interact") and interactable:
		if player!=null:
			player.player_has_stick = true
			queue_free()

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		player=body
		interactable = true
		set_key_shown(true)

func _on_body_exited(body:Node2D):
	if body.is_in_group("player"):
		player = null
		interactable=false
		set_key_shown(false)
func set_key_shown(state:bool):
	key.visible=state
