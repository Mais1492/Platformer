extends Control

var level := 1
var score = 0	
var player = null
var buff_active := false
@onready var score_label: Label = $"Score-Label"
@onready var level_label: Label = $"Level-Label"
@onready var timer_label: Label = $"Timer-Label"

@onready var border: Panel = $Border

func set_player(p):
	player = p
	player.speed_buff_changed.connect(_on_speed_buff_changed)


func _on_speed_buff_changed(active: bool):
	buff_active = active


func _process(delta):
	if buff_active:
		border.visible = true
		border.modulate.a = 0.5 + sin(Time.get_ticks_msec() * 0.01) * 0.3
	else:
		border.visible = false

func add_point():
	score += 1
	score_label.text = "Score: " + str(score)
	
	var new_level = int(score / 3) + 1
	
	if (new_level > level):
		level = new_level
		_on_level_up()
		
func _on_level_up():
	level_label.text = "Level: " + str(level)
	increase_stats()
	ResourceSaver.save(player.stats, "user://player_stats.tres")
	
func update_timer(time: float):
	timer_label.text = "Remaining: " + str(int(ceil(time))) + "s"
	
func increase_stats():
	print("STAT INCREASE!")
	if level >= 2 and not player.stats.double_jump_enabled:
		player.stats.double_jump_enabled = true
		print("Double Jump Unlocked!")
	# TODO add level up dialog
	#player.stats.speed += 1
	#player.stats.jump_velocity += 1
	#player.stats.acceleration += 1
	#player.stats.friction += 1
	#player.stats.speed_buff_mult += 1
	#player.stats.speed_buff_duration += 1
