extends CharacterBody3D

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

const SPEED = 5.0
const JUMP_VELOCITY = 10.5

var dash_enabled = true
var dash_factor = 2
var speed_multiplier: float = 1.0
var push_velocity: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		dash_enabled = false
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var factor = 1
		if(Input.is_action_pressed("Dash") && dash_enabled):
			factor = dash_factor
		velocity.x = direction.x * SPEED * speed_multiplier * factor
		velocity.z = direction.z * SPEED * speed_multiplier * factor
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# For example speed platform which pushes the char
	velocity.x += push_velocity.x
	velocity.z += push_velocity.z

	move_and_slide()
