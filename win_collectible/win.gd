extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	get_tree().change_scene_to_file("res://src/win_screen/win_screen.tscn")
	queue_free()
