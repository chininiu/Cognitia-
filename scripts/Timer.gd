extends Control

@onready var timer_label = %timer_label
var time:float= 0.0
var player_minute := flashcards.minutes
var player_second:= flashcards.seconds
var stopped :bool = false
signal timesup

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	
func _process(delta : float):
	if player_minute < 0:
		timer_label.text = "Time's up"
		timer_label.add_theme_color_override("font_color" , Color(179, 0, 0))
		timesup.emit()
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	if global_var.questions_arr.size() == 0:
		timesup.emit()
		return
	time += delta
	timer_update()
	

func update_timer() -> String:
	var sec := fmod(time,61)
	var second_minus_player := player_second - sec
	if second_minus_player < 0 :
		player_second = 60
		time = 0
		player_minute = player_minute - 1
	var format =" : %02d"
	var final_string = str(player_minute) + format % [second_minus_player]
	return final_string
	
func timer_update():
	if player_minute >= 0 :
		timer_label.text = update_timer()
