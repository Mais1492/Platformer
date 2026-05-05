extends StaticBody3D

@export var destroy_delay: float = 0.2
@export var cleanup_delay: float = 0.45

@onready var trigger_area: Area3D = $TriggerArea
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var break_particles: GPUParticles3D = $BreakParticles

var destroyed: bool = false


func _ready() -> void:
	trigger_area.body_entered.connect(_on_body_entered)
	_configure_particles_if_needed()


func _on_body_entered(body: Node) -> void:
	if destroyed:
		return
	if body is CharacterBody3D:
		destroyed = true
		_start_destroy_sequence()


func _start_destroy_sequence() -> void:
	await get_tree().create_timer(destroy_delay).timeout
	_break_now()


func _break_now() -> void:
	if collision_shape != null:
		collision_shape.disabled = true

	if trigger_area != null:
		trigger_area.monitoring = false
		trigger_area.monitorable = false
		for child in trigger_area.get_children():
			if child is CollisionShape3D:
				child.disabled = true

	for child in get_children():
		if child is MeshInstance3D:
			child.visible = false

	if break_particles != null:
		break_particles.restart()
		break_particles.emitting = true

	await get_tree().create_timer(cleanup_delay).timeout
	queue_free()


func _configure_particles_if_needed() -> void:
	if break_particles == null:
		return

	if break_particles.process_material == null:
		var mat := ParticleProcessMaterial.new()
		mat.direction = Vector3.UP
		mat.initial_velocity_min = 3.0
		mat.initial_velocity_max = 6.0
		mat.gravity = Vector3(0.0, -12.0, 0.0)
		mat.spread = 90.0
		mat.scale_min = 0.15
		mat.scale_max = 0.28
		break_particles.process_material = mat

	if break_particles.draw_pass_1 == null:
		var quad := QuadMesh.new()
		quad.size = Vector2(0.16, 0.16)
		break_particles.draw_pass_1 = quad
