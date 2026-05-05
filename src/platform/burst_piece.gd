extends Area3D

@export var initial_speed: float = 7.5
@export var fall_acceleration: float = 12.0
@export var launch_velocity: float = 20.0
@export var life_time: float = 1.4

var vertical_velocity: float = 0.0


func _ready() -> void:
	vertical_velocity = initial_speed
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	vertical_velocity -= fall_acceleration * delta
	global_position.y += vertical_velocity * delta

	life_time -= delta
	if life_time <= 0.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body is CharacterBody3D:
		body.velocity.y = max(body.velocity.y, launch_velocity)
		queue_free()
