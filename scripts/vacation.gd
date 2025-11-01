extends Node2D

var main_menu:PackedScene = preload("res://scenes/loading_to_main.tscn")

func _on_texture_button_pressed() -> void:
	flashcards.minutes = 0
	flashcards.seconds = 0
	global_var.questions_arr = []
	global_var.answer_arr = []
	global_var.temp_answer_arr = []
	global_var.temp_questions_arr =[]
	global_var.user_answer = {}
	global_var.ImageAndLabel = {}
	DFS.orb_places = []
	get_tree().change_scene_to_packed(main_menu)
