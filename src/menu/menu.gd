extends Control

const WORLD = preload("uid://c1mos3voqrhfd")
@onready var v_box_container: VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	# TODO EDIT SCENE
	get_tree().change_scene_to_file("res://src/world/world.tscn")
	
func _on_exit_pressed() -> void:
	get_tree().quit()
	


func _on_video_stream_player_finished() -> void:
	v_box_container.visible = true
	pass # Replace with function body.
