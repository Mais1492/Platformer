extends Control

@onready var label: Label = $Label
const CHARACTER = preload("uid://dn4phws75yuxp")

var score = 0
@onready var player = get_tree().current_scene.find_child("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player):
		label.text = str(player.position.y)
