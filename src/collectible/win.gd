extends Area3D

@export var next_scene: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	SFX.play("star")
	get_tree().change_scene_to_file(next_scene)
	queue_free()
