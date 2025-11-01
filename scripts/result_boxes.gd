extends Control

@onready var user_answer :Label= %user_answer
@onready var question :Label= %question
@onready var correct_answer: Label = %correct_answer
@onready var show_button: Button = %show_button

func _on_show_button_pressed() -> void:
	if question.visible:
		user_answer.visible = true
		correct_answer.visible = true
		question.visible = false
		show_button.text = "SHOW QUESTION"
	elif !question.visible:
		user_answer.visible = false
		correct_answer.visible = false
		question.visible = true
		show_button.text = "SHOW ANSWER"
