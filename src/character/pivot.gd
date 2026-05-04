extends Node3D

@export var sensitivity: float = 0.003
@export var max_pitch: float = 1.4   # ~80 degrees
@export var min_pitch: float = -1.4

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D

func _ready() -> void:
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		var player = get_parent() as CharacterBody3D
		if player:
			player.rotate_y(-event.relative.x * sensitivity)
		
		rotation.x -= event.relative.y * sensitivity
		rotation.x = clamp(rotation.x, min_pitch, max_pitch)

func _process(_delta: float) -> void:
	pass
