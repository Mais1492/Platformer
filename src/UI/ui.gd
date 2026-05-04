extends Control

var score = 0	
var player = null
var buff_active := false

@onready var label: Label = $Label
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
	label.text = "Score: " + str(score)
