extends Node2D

func _ready() -> void:
	Events.npc_interacted.connect(_on_npc_interacted)

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
		Dialogue.queue_choices(
			"Luna the Alchemist",
			"res://assets/dialogue-images/alchemist.png",
			["Look for the book", "Use one of the Herbs"],
			func(i):
				if i == 0:
					print("looking for the book")
				else:
					print("using a herb")
		)
		pass
