extends StaticBody3D

const SPEED_MULTIPLIER = 5.0
@export var push_direction: Vector3 = Vector3(1, 0, 0)
@export var push_speed: float = 13.0

@onready var speed_area: Area3D = $SpeedArea


func _ready() -> void:
	speed_area.body_entered.connect(_on_body_entered)
	speed_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.speed_multiplier = SPEED_MULTIPLIER
		body.push_velocity = push_direction.normalized() * push_speed


func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.speed_multiplier = 1.0
		body.push_velocity = Vector3.ZERO
