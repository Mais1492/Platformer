extends Node3D

@onready var player: CharacterBody3D = $player
@onready var timer = GameTimer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Ui.set_player(player)
	timer.start()
	timer.timeout.connect(_on_time_up)
	
func _process(delta):
	Ui.update_timer(timer.time_left)

func _on_time_up():
	print("GAME OVER")
	get_tree().change_scene_to_file("res://src/main_menu/main_menu.tscn")
