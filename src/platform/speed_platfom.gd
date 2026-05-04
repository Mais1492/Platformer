extends StaticBody3D

const SPEED_MULTIPLIER = 5.0
const ACCELERATION_MULTIPLIER = 2.0

@onready var speed_area: Area3D = $SpeedArea

var bodies_in_area: Array = []

func _ready() -> void:
	speed_area.body_entered.connect(_on_body_entered)
	speed_area.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	for body in bodies_in_area:
		if body is CharacterBody3D:
			body.speed_multiplier = SPEED_MULTIPLIER
			body.acceleration_multiplier = ACCELERATION_MULTIPLIER

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		bodies_in_area.append(body)
		
func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		bodies_in_area.erase(body)
		body.speed_multiplier = 1.0
		body.acceleration_multiplier = 1.0
