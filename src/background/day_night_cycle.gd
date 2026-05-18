extends Node3D

@export var day_length_seconds: float = 300.0     # 5 minutes per full day
@export var start_time: float = 0.25              # Start at sunrise

@onready var sun: DirectionalLight3D = $Sun
@onready var world_env: WorldEnvironment = get_parent() as WorldEnvironment

var time_of_day: float = 0.0

func _ready() -> void:
	if not sun:
		sun = DirectionalLight3D.new()
		sun.name = "Sun"
		sun.shadow_enabled = true
		add_child(sun)
	
	time_of_day = start_time

func _process(delta: float) -> void:
	time_of_day += delta / day_length_seconds
	time_of_day = fmod(time_of_day, 1.0)
	
	_update_sun_and_sky()

func _update_sun_and_sky() -> void:
	if not world_env or not world_env.environment:
		return
	
	var env: Environment = world_env.environment
	if not env.sky or not env.sky.sky_material is ProceduralSkyMaterial:
		return
	
	var sky_mat: ProceduralSkyMaterial = env.sky.sky_material
	
	# === SUN ANGLE - Better for vertical games ===
	# We want the sun to move mostly horizontally across the sky
	# instead of circling vertically around the player
	
	var sun_angle = time_of_day * TAU  * 1         # Full circle
	var elevation = PI * 0.45                  # Fixed height of sun (≈ 63° above horizon)
	
	# Rotate the sun
	sun.rotation.x = elevation
	sun.rotation.y = sun_angle                 # This makes it move across the sky nicely
	
	# Optional: Small tilt so it doesn't feel too flat
	# sun.rotation.z = 0.1
	
	# === Sun Light Strength & Color ===
	var sun_energy = smoothstep(0.1, 0.3, time_of_day) * smoothstep(0.8, 0.6, time_of_day)
	
	sun.light_energy = lerp(0.0, 2.2, sun_energy)
	sun.light_color = lerp(Color(0.6, 0.7, 1.0), Color(1.0, 0.95, 0.8), sun_energy)
	
	# === Sky Colors ===
	sky_mat.sky_top_color = lerp(Color(0.01, 0.0, 0.08), Color(0.4, 0.65, 1.0), sun_energy)
	sky_mat.sky_horizon_color = lerp(Color(0.08, 0.02, 0.18), Color(0.85, 0.9, 1.0), sun_energy)
	
	sky_mat.ground_bottom_color = lerp(Color(1.0, 1.0, 1.0, 1.0), Color(0.985, 0.982, 0.978, 1.0), sun_energy)
	sky_mat.ground_horizon_color = lerp(Color(1.0, 1.0, 1.0, 1.0), Color(0.75, 0.7, 0.65), sun_energy)
	
	sky_mat.sky_energy_multiplier = lerp(0.2, 1.4, sun_energy)
