extends Control

var level := 1
var score = 0	
var player = null
var buff_active := false
@onready var score_label: Label = $"Score-Label"
@onready var level_label: Label = $"Level-Label"
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
	print("LEVEL UP!")
