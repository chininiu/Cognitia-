extends Control

var display_quest : String
var index :int 
@onready var question_d : Label = %question_d
@onready var answer_d : LineEdit = %answer_d
@onready var image_question : TextureRect = %image_question
@onready var correct :String= global_var.answer_arr[index]
@onready var answer_hint: Label = %answer_hint
@onready var show_label : Button = %show_label
@onready var zoom_background : Panel = %zoom_background
@onready var zoomed_image : TextureRect = %zoomed_image
@onready var no_of_hints : Label = %no_of_hints
var ran = RandomNumberGenerator.new()
var arr_num = []
var user :String
var image_path
signal orb_free
signal wrong
signal right

func _ready() -> void:
	get_tree().paused = true
	no_of_hints.text = str(global_var.no_of_hints)
	display_question()
	display_corr_answer()
func _process(_delta: float) -> void:
		if Input.is_action_just_pressed("enter") && answer_d.text.length() > 0:
			user = str(answer_d.text)
			if !global_var.questions_arr[index].contains("IsImagePath") :
				global_var.user_answer[question_d.text] = user
			else:
				global_var.user_answer[global_var.questions_arr[index]] = user
			is_answer_correct()

func display_question():
	if global_var.questions_arr.size() > 0:
		if !(global_var.questions_arr[index].contains("IsImagePath")):
			#set visible false for image if there is isImagePath
			image_question.visible = false
			question_d.visible = true
			show_label.visible = false
			image_question.process_mode = Node.PROCESS_MODE_DISABLED
			question_d.process_mode = Node.PROCESS_MODE_INHERIT
			question_d.text = global_var.questions_arr[index]
			show_label.process_mode = Node.PROCESS_MODE_DISABLED
			
		elif global_var.questions_arr[index].contains("IsImagePath"):
			var img: Image = Image.new()
			var image_texture : ImageTexture = ImageTexture.new()
			var quest : String = global_var.questions_arr[index]
			#sbstr to remove the isImagePAth
			img.load(quest.substr(12,-1))
			image_path = img
			image_texture.set_image(img)
			if global_var.ImageAndLabel[quest] != "":
				question_d.text = global_var.ImageAndLabel[quest]
			elif global_var.ImageAndLabel[quest] == "":
				question_d.text = "No Label"
			image_question.visible = true
			question_d.visible = false
			show_label.visible = true
			image_question.process_mode = Node.PROCESS_MODE_INHERIT
			question_d.process_mode = Node.PROCESS_MODE_DISABLED
			show_label.process_mode = Node.PROCESS_MODE_INHERIT
			image_question.texture = image_texture
	else:
		pass

func _on_skip_pressed() -> void:
	user = str(answer_d.text)
	if !global_var.questions_arr[index].contains("IsImagePath") :
		global_var.user_answer[question_d.text] = user
	else:
		global_var.user_answer[global_var.questions_arr[index]] = user
	global_var.questions_arr.remove_at(index)
	global_var.answer_arr.remove_at(index)
	get_tree().paused = false
	orb_free.emit()
	wrong.emit()
	self.queue_free()
	
func _on_submit_pressed() -> void:
	user = str(answer_d.text)
	if !global_var.questions_arr[index].contains("IsImagePath") :
		global_var.user_answer[question_d.text] = user
	else:
		global_var.user_answer[global_var.questions_arr[index]] = user
	print(global_var.user_answer)
	is_answer_correct()

func is_answer_correct():
	if global_var.space  && !global_var.symbols && !global_var.typo:
		space_toggled()
		
	elif global_var.symbols &&  !global_var.space && !global_var.typo:
		symbol_toggled()
		
	elif global_var.typo && !global_var.symbols && !global_var.space:
		if typo_toggled():
			right.emit()
			remove_resource()
			return
		elif !typo_toggled():
			wrong.emit()
			remove_resource()
			return
	elif global_var.space && global_var.symbols && global_var.typo:
		symbol_toggled()
		space_toggled()
		if typo_toggled():
			right.emit()
			remove_resource()
			return
		else:
			wrong.emit()
			remove_resource()
			return
			
	elif global_var.space && global_var.symbols && !global_var.typo:
		symbol_toggled()
		space_toggled()
		
	elif global_var.space && !global_var.symbols && global_var.typo:
		space_toggled()
		if typo_toggled():
			right.emit()
			remove_resource()
			return
		else:
			wrong.emit()
			remove_resource()
			return
			
	elif !global_var.space && global_var.symbols && global_var.typo:
		symbol_toggled()
		if typo_toggled():
			right.emit()
			remove_resource()
			return
		else:
			wrong.emit()
			remove_resource()
			return
			
	elif !global_var.typo && !global_var.symbols && !global_var.space:
		check_answer()
		return
		
	if user.to_upper() == correct.to_upper():
		right.emit()
		remove_resource()
		
	elif user.to_upper() != correct.to_upper():
		wrong.emit()
		remove_resource()
		
func space_toggled():
	user = user.replace(" ","").replace("\t","").replace("\n", "")
	correct = correct.replace(" ","").replace("\t","").replace("\n", "")
	
func symbol_toggled():

	user = user.replace("." , "").replace(";", "").replace("!","").replace("_" , "").replace("-", "").replace("?","").replace("&", "").replace("%","").replace("/" , "")
	correct = correct.replace("." , "").replace(";", "").replace("!","").replace("_" , "").replace("-", "").replace("?","").replace("&", "").replace("%","").replace("/" , "")  

func typo_toggled() -> bool:
	var is_right: bool = false
	if correct.length() > 3 :
		if user.length() == correct.length():
			var wrong_count :int = 0
			for n in range(correct.length()):
				if user[n] == correct[n]:
					is_right = true
				elif user[n] != correct[n]:
					wrong_count = wrong_count + 1
				if wrong_count > 2:
					is_right = false
	else:
		if user.to_lower() == correct.to_lower():
			is_right = true
		else:
			is_right = false
	return is_right

func check_answer():
	if user.to_lower() == correct.to_lower():
		right.emit()
	elif user.to_lower() != correct.to_lower():
		wrong.emit()
	global_var.questions_arr.remove_at(index)
	global_var.answer_arr.remove_at(index)
	orb_free.emit()
	get_tree().paused = false
	self.queue_free()

func remove_resource():
	global_var.questions_arr.remove_at(index)
	global_var.answer_arr.remove_at(index)
	orb_free.emit()
	get_tree().paused = false
	self.queue_free()

func display_corr_answer():
	var char_cout :int= correct.length() 
	for n in range((char_cout)):
		answer_hint.text = answer_hint.text  + "-"

func _on_hint_button_pressed() -> void:
	var char_cout :int= correct.length()
	var random_num :int = ran.randi_range(0, (arr_num.size() - 1))
	if global_var.no_of_hints > 0:
		if arr_num.size() == 0:
#if the the num of array is empty, then it checks and add the number of correct length
			if answer_hint.text.find("-") != -1 :
				for n in char_cout:
					arr_num.append(n)
			if answer_hint.text.find("-") == -1 :
				return
		if arr_num.size() != 0:
			global_var.no_of_hints = global_var.no_of_hints - 1
			no_of_hints.text = str(global_var.no_of_hints )
			answer_hint.text[arr_num[random_num]] = correct[arr_num[random_num]]
			arr_num.remove_at(random_num)
		else:
			pass

func _on_show_label_pressed() -> void:
	if !question_d.visible:
		image_question.visible = false
		question_d.visible = true
		question_d.process_mode = Node.PROCESS_MODE_INHERIT
	elif question_d.visible:
		image_question.visible = true
		question_d.visible = false
		question_d.process_mode = Node.PROCESS_MODE_DISABLED

func _on_zoom_button_pressed() -> void:
	var image: ImageTexture = ImageTexture.new()
	zoom_background.process_mode = Node.PROCESS_MODE_INHERIT
	image.set_image(image_path)
	zoomed_image.texture = image
	zoom_background.visible = true
	
func _on_unzoom_button_pressed() -> void:
	pass # Replace with function body.
	zoom_background.process_mode = Node.PROCESS_MODE_DISABLED
	zoom_background.visible = false
