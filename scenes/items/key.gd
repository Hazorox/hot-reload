extends TextureRect

const assets_path := "res://assets/key_btns/Pixel Keyboard Lite/PNG Sprites/1 Bit/pkl_lite_keys_0_one_letter_%s.png"
var letter := ""
func _ready() -> void:
	for e in InputMap.action_get_events("interact"):
		if e is InputEventKey:
			letter = e.as_text_physical_keycode().trim_suffix(" - Phyiscal")
	var full_path := assets_path % letter.to_lower()
	texture = load(full_path)
