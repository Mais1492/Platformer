extends Area3D

const UI = preload("uid://d2aqighs5s3dy")

func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body):
	if body is CharacterBody3D:
		body.activate_speed_buff()
		queue_free()
