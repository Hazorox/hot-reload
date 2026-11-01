extends Node2D
@onready var progress_bar: TextureProgressBar = $ProgressBar

func _process(delta: float) -> void:
	progress_bar.value = ViiGlobals.player_health
