extends Node2D

@onready var ing = [$death, $life]
@onready var book = $Slow

@export var boss_scene : PackedScene = null
@export var winning_screen : PackedScene = null

var waiting_for_choice := false

func _ready() -> void:
	Events.npc_interacted.connect(_on_npc_interacted)
	Events.book_found.connect(_book_found)
	Events.death_leaf.connect(die)
	Dialogue.choice_made.connect(_on_choice_made)
	for i in ing:
		set_active(i, false)
	book.enable(false)

func set_active(node: Node, on: bool) -> void:
	if node.has_method("enable"):
		node.enable(on)
	else:
		node.visible = on
		
func _on_choice_made(i: int) -> void:
	if not waiting_for_choice:
		return
	waiting_for_choice = false
	if i == 0:
		book.enable(true)
	else:
		for j in ing:
			set_active(j, true)

func _on_npc_interacted(id: String) -> void:
	if id == "alchemist":
		print("4. parent got it")
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"Welcome to my shop!",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"You look tired... Pale as a dead leaf",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Human",
			"res://assets/dialogue-images/player.png",
			"I have been cursed by an evil wizard and I need a cure",
			"res://assets/sound_beeps/freesound_community-bllrr-text-loop-82399.mp3"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"I will cure u for free...",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"but there is a catch...",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"In this forest, every choice has its consequences...",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"So, I am going to give u a choice...",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"I lost my recipe book yesterday...",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"If u can find it I will 100% be able to cure u",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"If u are so rushed u can pick one of the 2 herbs at the end of my store",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"One of them may cure u and the other may instantly kill u... idk",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"It is ur choice",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
		waiting_for_choice = true
		Dialogue.queue_choices(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			["Look for the book", "Use one of the Herbs"]
		)
		pass
		
func _book_found():
	Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"I sense that u found my book",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
	Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"U prolly already know that this was a test",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
	Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"To reward u, gonna cure use using bluetooth",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
	Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"*bluetooth device is connected successfully*",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
	await Dialogue.finished
	Globals.switch_scene(winning_screen, 0.67)

func die():
	Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"gonna make u the potion right away",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
	
	Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"Oh.. I think this one is the instant death potion",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
	Dialogue.queue_text(
			"Human",
			"res://assets/dialogue-images/player.png",
			"One sec I'll get u the oth-",
			"res://assets/sound_beeps/freesound_community-bllrr-text-loop-82399.mp3"
		)
	Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"Can't let it go to waste :3",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
	Dialogue.queue_text(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			"*forces u to drink it*",
			"res://assets/sound_beeps/susie_s_dialogue.wav"
		)
	await Dialogue.finished
	Globals.switch_scene(boss_scene, 0.67)
