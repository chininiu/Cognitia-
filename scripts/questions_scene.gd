extends Control
class_name flashcards
const flash_card :PackedScene= preload("res://scenes/flashcards.tscn")
const img_flash_card:PackedScene = preload("res://scenes/image_flashcard.tscn")
@onready var dec_sec :Control= %decrement_seconds
@onready var dec_min :Control= %decrement_minute
@onready var inc_sec :Control= %increment_seconds
@onready var inc_min :Control= %increment_minute
@onready var min_dis :Control= %minutes
@onready var sec_dis :Control = %second
@onready var notice_label:Control = %notice_label
@onready var vbox_ques : VBoxContainer = %vbox_ques
@onready var no_of_flashcard:Label = %no_of_flashcard
var noflashcards = 0

static var minutes :int = 0
static var seconds : int = 0
var format = "%02d"
var check_sec : bool = false
var check_min :bool = false
static var edit: bool = false

func _ready():
	min_dis.text = format % [minutes]
	sec_dis.text = format % [seconds]
	if edit:
		edit = false
		refresh_flashcards()
		noflashcards = vbox_ques.get_child_count()
		for n in vbox_ques.get_children():
			n.connect("has_delete", auto_decrement)
		no_of_flashcard.text = str(noflashcards)

func _process(_delta):
	time_logic()

func check_if_flashcard_null() -> bool:
	#checkd if one of the card's q and a is null
	var check:bool = false
	for child in vbox_ques.get_children():
		if child.name.contains("flashcards"):
			if child.get_node("NinePatchRect/question").text.is_empty() || child.get_node("NinePatchRect/answer").text.is_empty():
				check = false
				break
			else:
				check = true
		if child.name.contains("image"):
			if child.get_node("NinePatchRect/question").texture == null || child.get_node("NinePatchRect/answer").text.is_empty():
				check = false
				break
			else:
				check =true
	return check

func _on_increment_seconds_pressed():
	seconds = seconds + 1
	sec_dis.text = format % [seconds]

func _on_decrement_seconds_pressed():
	seconds = seconds - 1
	sec_dis.text = format % [seconds]

func time_logic() -> void:
#time seconds logic
	dec_min.disabled = check_min
	dec_sec.disabled = check_sec
	if seconds < 0 && minutes > 0:
		minutes = minutes - 1
		seconds = 59
		min_dis.text = format % [minutes]
		sec_dis.text = format % [seconds]
		
	if seconds <= 0 && minutes == 0:
		check_sec = true
	elif seconds > 0:
		check_sec = false
# minutes increment if seconds is greater than 59
	if seconds == 60:
		seconds = 0
		minutes = minutes + 1
		sec_dis.text = format % [seconds]
		min_dis.text = format % [minutes]
	
#minute logic
	if minutes <= 0:
		check_min = true
	elif minutes > 0:
		check_min = false
		check_sec = false

func _on_increment_minute_pressed():
	minutes = minutes + 1
	min_dis.text = format % [minutes]

func _on_decrement_minute_pressed():
	minutes = minutes - 1
	min_dis.text =  format % [minutes]

func set_timer_check() ->bool: 
	var is_check = true
	if seconds == 0 && minutes > 0:
		is_check = true
	if seconds > 0 && minutes == 0:
		is_check = true
	if seconds == 0 && minutes == 0:
		is_check = false
	return is_check

func _on_card_btn_pressed() -> void:
	var new_fc :Control= flash_card.instantiate()
	vbox_ques.add_child(new_fc)
	vbox_ques.move_child(new_fc, 0)
	new_fc.connect("has_delete", auto_decrement)
	new_fc.name = "flashcards"
	noflashcards = noflashcards +  1
	no_of_flashcard.text = str(noflashcards)
	auto_timer()

func _on_start_btn_pressed() -> void:
	#check if flashcard have values, if true, proceed to next scene
	if check_if_flashcard_null() && set_timer_check():
		for child in vbox_ques.get_children():
			if child.name.contains("flashcards"):
				var put_quest :String= str(child.get_node("NinePatchRect/question").text)
				var put_ans:String= str(child.get_node("NinePatchRect/answer").text)
				global_var.answer_arr.append(put_ans)
				global_var.questions_arr.append(put_quest)
				
			elif child.name.contains("image"):
				var put_img :String= ("IsImagePath " + child.path_image)
				var put_imgAns: String =  str(child.get_node("NinePatchRect/answer").text)
				global_var.ImageAndLabel[put_img] = child.get_node("NinePatchRect/label").text
				global_var.questions_arr.append(put_img)
				global_var.answer_arr.append(put_imgAns)
		get_tree().change_scene_to_file("res://scenes/world_loading_controller.tscn")
		
	if vbox_ques.get_children().size() == 0:
		notice_label.text = "Add some cards"
		await get_tree().create_timer(5).timeout
		notice_label.text = ""
	elif !(check_if_flashcard_null()):
		notice_label.text = "Fill all the cards"
		await get_tree().create_timer(5).timeout
		notice_label.text = ""
	elif !(set_timer_check()):
		notice_label.text = "Set the timer"
		await get_tree().create_timer(5).timeout
		notice_label.text = ""
	
func _on_return_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_to_main.tscn")

func _on_img_btn_pressed() -> void:
	var flashcard_img = img_flash_card.instantiate()
	vbox_ques.add_child(flashcard_img)
	vbox_ques.move_child(flashcard_img, 0)
	flashcard_img.connect("has_delete", auto_decrement)
	flashcard_img.name = "image"
	noflashcards = noflashcards +  1
	no_of_flashcard.text = str(noflashcards)
	auto_timer()

func auto_timer() ->void:
	if global_var.auto:
		auto_increment()

func auto_increment() -> void:
	var no_flashcards :int= vbox_ques.get_child_count()
	minutes = no_flashcards * 1
	seconds = 0
	min_dis.text = format % [minutes]
	sec_dis.text = format % [seconds]

func auto_decrement() -> void:
	if global_var.auto:
		if minutes > 0:
			minutes = minutes - 1
			seconds = 0
			min_dis.text = format % [minutes]
			sec_dis.text = format % [seconds]
		else:
			pass
	noflashcards = noflashcards -  1
	no_of_flashcard.text = str(noflashcards)
	
func refresh_flashcards():
	for n:String in global_var.temp_questions_arr:
		var index: int = global_var.temp_questions_arr.find(n)
		if n.contains("IsImagePath"):
			var new :String= n.substr(12,-1)
			var img_card = img_flash_card.instantiate()
			var img : Image = Image.new()
			var texture: ImageTexture = ImageTexture.new()
			img.load(new)
			texture.set_image(img)
			vbox_ques.add_child(img_card)
			img_card.path_image = new
			img_card.get_node(NodePath("NinePatchRect/question")).texture = texture
			img_card.get_node(NodePath("NinePatchRect/answer")).text = str(global_var.temp_answer_arr[index])
			img_card.get_node(NodePath("NinePatchRect/label")).text = global_var.ImageAndLabel[n]
			img_card.name = "image"
		elif !n.contains("IsImagePath"):
			var card = flash_card.instantiate()
			vbox_ques.add_child(card)
			card.get_node("NinePatchRect/question").text = n
			card.get_node("NinePatchRect/answer").text = str(global_var.temp_answer_arr[index])
			card.name = "flashcards"
	global_var.temp_answer_arr = []
	global_var.temp_questions_arr =[]
	print()

func _on_img_btn_mouse_entered() -> void:
	notice_label.text = "Insert Flashcard w Image"
func _on_img_btn_mouse_exited() -> void:
	notice_label.text = ""
func _on_card_btn_mouse_entered() -> void:
	notice_label.text = "Insert Flashcard"
func _on_card_btn_mouse_exited() -> void:
	notice_label.text = ""
