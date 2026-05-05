extends CharacterBody3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@export var stats: PlayerStats

var save_path = "user://player_stats.tres"

var speed_buff_timer: float = 0.0
var speed_buff_active := false

var speed_multiplier: float = 1.0
var jump_multiplier: float = 1.0
var acceleration_multiplier: float = 1.0
var friction_multiplier: float = 1.0
var jump_count: int = 0

signal speed_buff_changed(active: bool)

func _ready():
	add_to_group("character")
	get_tree().call_group("ui", "register_player", self)
	
	if ResourceLoader.exists(save_path):
		stats = ResourceLoader.load(save_path)
	else : stats = preload("res://src/character/player_stats.tres").duplicate()

	stats.double_jump_enabled = false
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
	else:
		jump_count = 0

	if speed_buff_active:
		speed_buff_timer -= delta
		if speed_buff_timer <= 0:
			speed_multiplier = 1.0
			speed_buff_active = false
			speed_buff_changed.emit(false)

	# Handle jump.
	var max_jumps := 2 if stats.double_jump_enabled else 1
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = stats.jump_velocity * jump_multiplier
		jump_count += 1
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://src/main_menu/main_menu.tscn")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var target_velocity = direction * stats.speed * speed_multiplier
		
	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, target_velocity.x, stats.acceleration * acceleration_multiplier * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, stats.acceleration * acceleration_multiplier * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, stats.friction * friction_multiplier * delta)
		velocity.z = move_toward(velocity.z, 0, stats.friction * friction_multiplier * delta)

	move_and_slide()

func activate_speed_buff():
	speed_multiplier = stats.speed_buff_mult
	speed_buff_timer = stats.speed_buff_duration
	speed_buff_active = true
	speed_buff_changed.emit(true)
