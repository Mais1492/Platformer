extends CharacterBody3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

const BASE_SPEED = 10.0
const BASE_JUMP_VELOCITY = 10.5
const BASE_ACCELERATION = 30.0
const BASE_FRICTION = 12.0

const SPEED_BUFF_MULT = 2.0
const SPEED_BUFF_DURATION = 10.0

var speed_buff_timer: float = 0.0
var speed_buff_active := false

var speed_multiplier: float = 1.0
var jump_multiplier: float = 1.0
var acceleration_multiplier: float = 1.0
var friction_multiplier: float = 1.0

signal speed_buff_changed(active: bool)

func _ready():
	add_to_group("character")
	get_tree().call_group("ui", "register_player", self)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	if speed_buff_active:
		speed_buff_timer -= delta
		if speed_buff_timer <= 0:
			speed_multiplier = 1.0
			speed_buff_active = false
			speed_buff_changed.emit(false)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = BASE_JUMP_VELOCITY * jump_multiplier
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://src/main_menu/main_menu.tscn")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var target_velocity = direction * BASE_SPEED * speed_multiplier
		
	if direction != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, target_velocity.x, BASE_ACCELERATION * acceleration_multiplier * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, BASE_ACCELERATION * acceleration_multiplier * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, BASE_FRICTION * friction_multiplier * delta)
		velocity.z = move_toward(velocity.z, 0, BASE_FRICTION * friction_multiplier * delta)

	move_and_slide()

func activate_speed_buff():
	speed_multiplier = SPEED_BUFF_MULT
	speed_buff_timer = SPEED_BUFF_DURATION
	speed_buff_active = true
	speed_buff_changed.emit(true)
