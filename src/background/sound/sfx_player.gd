extends Node

var player: AudioStreamPlayer

var sounds = {
	"double-jump": preload("res://assets/sfx/double-jump.ogg"),
	"star": preload("res://assets/sfx/star.ogg"),
	"speed": preload("res://assets/sfx/speed.ogg"),
	"barrel": preload("res://assets/sfx/barrel.ogg"),
	#TODO add more SFX
	#"jump": preload("res://assets/sfx/jump.ogg"),
	#"push": preload("res://assets/sfx/push.ogg"),
	#"ice": preload("res://assets/sfx/ice.ogg"),
	#"pill": preload("res://assets/sfx/pill.ogg")
}

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	
func play(sound_name: String) -> void:
	if not player:
		push_error("SFX player not initialized yet")
		return

	if sounds.has(sound_name):
		player.stream = sounds[sound_name]
		player.pitch_scale = randf_range(0.95, 1.05)
		player.play()
	else:
		push_warning("SFX not found: " + sound_name)
