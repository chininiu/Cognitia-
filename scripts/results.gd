extends Control
class_name Result

static var right_question_res = []
static var wrong_question_res = []

@onready var result_container : VBoxContainer = %result_container
@onready var result_percentage : Label = %result_percentage
@onready var anim : AnimationPlayer = $anim
@onready var restart_btn : TextureButton = %restart_btn

const green:Theme = preload("res://assets/GUI RESOURCES/green_result.tres")
const red:Theme = preload("res://assets/GUI RESOURCES/red_result.tres")
const result_boxes :  PackedScene = preload("res://scenes/result_boxes.tscn")
var right :float = right_question_res.size()
var total :float = global_var.temp_questions_arr.size()
var percent : float = (right/total) * 100.0
var percent_formatted = "%0.2f" % percent

signal reset

func _ready() -> void:
	print(global_var.user_answer)
	display_result()
	if percent > 90.0:
		result_percentage.text = "WOW! You have answered your set of questions " + str(percent_formatted) + "% correctly!"
	elif percent < 90.0 && percent > 70.0:
		result_percentage.text = "GOOD! You have answered your set of questions " + str(percent_formatted) + "% correctly!"
	elif percent < 70.0:
		result_percentage.text = "PALAKOL! You have answered your set of questions " + str(percent_formatted) + "% correctly!"	
	anim.play("go_down")

func display_result():
	for n:String in right_question_res:
		if !n.contains("IsImagePath"):
			var result_box = result_boxes.instantiate()
			result_box.get_node("Panel/question").text = n
			if global_var.user_answer[n] != null:
				result_box.get_node("Panel/user_answer").text = ("Your Ans: " + str(global_var.user_answer[n]))
			result_box.get_node("Panel/correct_answer").text = ("Correct Ans: " + find_correct_answer(n))
			result_box.get_node("Panel").theme = green
			result_container.add_child(result_box)
		if n.contains("IsImagePath"):
			var result_box = result_boxes.instantiate()
			var image_path = n.substr(12,-1)
			var img : Image = Image.new()
			var tex : ImageTexture = ImageTexture.new()
			img.load(image_path)
			tex.set_image(img)
			result_box.get_node("Panel").theme = green
			if global_var.user_answer[n] != null:
				result_box.get_node("Panel/user_answer").text = ("Your Ans: " + str(global_var.user_answer[n]))
			result_box.get_node("Panel/correct_answer").text = ("Correct Ans: " + find_correct_answer(n))
			if global_var.ImageAndLabel[n] != "":
				result_box.get_node("Panel/question").text = global_var.ImageAndLabel[n]
			result_box.get_node("Panel/question_img").texture = tex
			result_container.add_child(result_box)
	for x in wrong_question_res:
		if !x.contains("IsImagePath"):
			var result_box = result_boxes.instantiate()
			if global_var.user_answer[x] != "":
				result_box.get_node("Panel/user_answer").text = ("Your Ans: " + str(global_var.user_answer[x]))
			result_box.get_node("Panel/correct_answer").text = ("Correct Ans: " + find_correct_answer(x))
			result_box.get_node("Panel/question").text = x
			result_box.get_node("Panel").theme = red
			result_container.add_child(result_box)
		if x.contains("IsImagePath"):
			var result_box = result_boxes.instantiate()
			var image_path = x.substr(12,-1)
			var img : Image = Image.new()
			var tex : ImageTexture = ImageTexture.new()
			img.load(image_path)
			tex.set_image(img)
			result_box.get_node("Panel").theme = red
			if global_var.user_answer[x] != "":
				result_box.get_node("Panel/user_answer").text = ("Your Ans: " + str(global_var.user_answer[x]))
			result_box.get_node("Panel/correct_answer").text = ("Correct Ans: " + find_correct_answer(x))
			if global_var.ImageAndLabel[x] != "":
				result_box.get_node("Panel/question").text = global_var.ImageAndLabel[x]
			result_box.get_node("Panel/question_img").texture = tex
			result_container.add_child(result_box)

func find_correct_answer(n:String) -> String:
	var find : int = global_var.temp_questions_arr.find(n)
	var correct_ans : String
	if find != -1:
		correct_ans = global_var.temp_answer_arr[find]
	return correct_ans

func _on_restart_btn_pressed() -> void:
	reset.emit()
