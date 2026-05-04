extends Node3D

@onready var player: CharacterBody3D = $player

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Ui.set_player(player)
