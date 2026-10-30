extends Control
@onready var panel: Panel = $MarginContainer/Panel
@onready var sprite: Sprite2D = $MarginContainer/MarginContainer/HBoxContainer/MarginContainer/Sprite2D
@onready var start: Label = $MarginContainer/MarginContainer/HBoxContainer/MarginContainer2/HBoxContainer/Start
@onready var end: Label = $MarginContainer/MarginContainer/HBoxContainer/MarginContainer2/HBoxContainer/End
@onready var textbox: RichTextLabel = $MarginContainer/MarginContainer/HBoxContainer/MarginContainer2/HBoxContainer/dialouge
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var speaker: Label = $name
signal finished
var queue: Array = []
var choices: Array = []
var callback: Callable
var index = 0
var tween: Tween

enum state{
	waiting,
	read,
	choosing,
	done,
}
var current = state.waiting

func _ready() -> void:
	hide_box()
	print("ready")
	process_mode = Node.PROCESS_MODE_ALWAYS
	queue_text("random flower", "res://assets/dialogue-images/player(mby).png", "I wanna die rn fr fr fr fr fr fr f rf rf rf rf rf rfrfr fr", "res://assets/sound_beeps/freesound_community-bllrr-text-loop-82399.mp3")
	queue_choices("random flower", "res://assets/dialogue-images/player(mby).png", ["study","suicide", "manslaughter"])
	queue_text("other random flower", "res://assets/dialogue-images/alchemist.png", "I wanna die rn fr fr fr fr fr fr f rf rf rf rf rf rfrfr fr", "res://assets/sound_beeps/susie_s_dialogue.wav")
	audio.finished.connect(func():
		if current == state.read:
			audio.play()
	)

func _process(delta: float) -> void:
	match current:
		state.waiting:
			if !queue.is_empty():
				var entry = queue.pop_front()
				match entry.type:
					"text": add_text(entry)
					"choices": add_choices(entry)
		state.read:
			if Input.is_action_just_pressed("ui_accept"):
				finish_reading()
		state.choosing:
			get_tree().paused=true
			if Input.is_action_just_pressed("ui_down"):
				index = posmod(index + 1, choices.size())
				render_choices()
			if Input.is_action_just_pressed("ui_up"):
				index = posmod(index - 1, choices.size())
				render_choices()
			if Input.is_action_just_pressed("ui_accept"):
				confirm_choice()
		state.done:
			if Input.is_action_just_pressed("ui_accept"):
				hide_box()
				if queue.is_empty():
					finished.emit()
				change_state(state.waiting)


func hide_box():
	panel.hide()
	sprite.hide()
	start.text = ""
	end.text = ""
	textbox.text = ""
	speaker.text = ""
	get_tree().paused = false

func show_box():
	panel.show()
	sprite.show()
	start.text = ""
	
func queue_text(talker: String, sprite_path: String, text: String, sound_path: String):
	queue.push_back({
		"type": "text",
		"text": text,
		"tex": sprite_path,
		"speaker": talker,
		"sound": sound_path
	})

func queue_choices(talker: String, sprite_path: String, options: Array, callback: Callable = Callable()):
	queue.push_back({
		"type": "choices",
		"options": options,
		"speaker": talker,
		"tex": sprite_path,
		"callback": callback
	})

func add_text(entry: Dictionary):
	var text: String = entry.text
	show_box()
	set_tex(entry.tex)
	speaker.text = entry.speaker
	textbox.text = text
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	textbox.visible_ratio = 0.0
	tween.tween_property(textbox, "visible_ratio", 1.0, 0.05 * text.length())
	tween.finished.connect(_on_tween_finished)
	change_state(state.read)
	audio.stream = load(entry.sound)
	audio.play()

func add_choices(entry: Dictionary):
	choices = entry.options
	callback = entry.callback
	index = 0
	show_box()
	change_state(state.choosing)
	speaker.text = entry.speaker
	set_tex(entry.tex)
	render_choices()

func render_choices():
	var lines: Array = []
	for i in choices.size():
		var pre
		if i == index:
			pre = "> "
		else:
			pre = " "
		lines.append(pre + str(choices[i]))
	textbox.text = "\n".join(lines)
	textbox.visible_ratio = 1.0
	
func confirm_choice():
	end.text = "v"
	change_state(state.done)
	if callback.is_valid():
		callback.call(index)
	get_tree().paused = false
	return index
	
func finish_reading():
	if tween and tween.is_valid():
		tween.kill()
	textbox.visible_ratio = 1.0
	end.text = "v"
	audio.stop()
	change_state(state.done)

func _on_tween_finished():
	finish_reading()

func change_state(next):
	current = next
	match current:
		state.waiting:
			print("ready")
		state.read:
			print("reading")
		state.choosing:
			print("choosing")
		state.done:
			print("done")

const PORTRAIT_SIZE := Vector2(210, 210)
func set_tex(path: String) -> void:
	var tex: Texture2D = load(path)
	sprite.texture = tex
	sprite.centered = true
	sprite.scale = PORTRAIT_SIZE / tex.get_size()
