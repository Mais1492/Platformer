extends StaticBody3D

@export var burst_interval: float = 1.5
@export var burst_piece_count: int = 6
@export var spawn_half_size: Vector2 = Vector2(2.3, 1.3)
@export var spawn_y_offset: float = -0.9
@export var burst_piece_scene: PackedScene = preload("res://src/platform/burst_piece.tscn")

@onready var burst_timer: Timer = $BurstTimer
@onready var burst_particles: GPUParticles3D = $BurstParticles


func _ready() -> void:
	burst_timer.timeout.connect(_on_burst_timeout)

	burst_timer.wait_time = burst_interval
	burst_timer.start()

	_configure_particles_if_needed()


func _on_burst_timeout() -> void:
	# Visual pulse from below platform.
	if burst_particles != null:
		burst_particles.restart()
		burst_particles.emitting = true

	_spawn_burst_pieces()


func _spawn_burst_pieces() -> void:
	if burst_piece_scene == null:
		return

	for i in burst_piece_count:
		var piece := burst_piece_scene.instantiate()
		if piece is Node3D:
			get_tree().current_scene.add_child(piece)
			var offset := Vector3(
				randf_range(-spawn_half_size.x, spawn_half_size.x),
				spawn_y_offset,
				randf_range(-spawn_half_size.y, spawn_half_size.y)
			)
			piece.global_position = global_position + offset


func _configure_particles_if_needed() -> void:
	if burst_particles == null:
		return

	if burst_particles.process_material == null:
		var mat := ParticleProcessMaterial.new()
		mat.direction = Vector3.UP
		mat.initial_velocity_min = 5.0
		mat.initial_velocity_max = 8.0
		mat.gravity = Vector3.ZERO
		mat.spread = 30.0
		mat.scale_min = 0.2
		mat.scale_max = 0.35
		burst_particles.process_material = mat

	if burst_particles.draw_pass_1 == null:
		var quad := QuadMesh.new()
		quad.size = Vector2(0.18, 0.18)
		burst_particles.draw_pass_1 = quad
