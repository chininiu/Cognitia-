extends Node2D
class_name World 

const max_t :float= 1

@onready var character = %CharacterBody2D
@onready var spawner_area = %spawner_area
@onready var container_popup = %pop_up_question
@onready var orbs_container = %orbs_container
@onready var spawn_area_shape = %spawn_area_shape
@onready var Tilemaplayer = %TileMapLayer
@onready var no_q :Array= global_var.questions_arr
@onready var wrong :Label = %no_wrong
@onready var correct :Label = %no_correct
@onready var interact_label: Label = %interact_label
@onready var setting_pop: CanvasLayer = %setting_pop
@onready var results_display :CanvasLayer= %results_display
@onready var timer :Control= %Timer
@onready var animation_result : AnimationPlayer= %animation_result
@onready var animation_emote : AnimationPlayer = %animation_emote
@onready var no_orb_dis : Label = %no_orbs_dis
@onready var loading : CanvasLayer = %loading
@onready var camera :AnimationPlayer = $camera
@onready var cam : Camera2D = %Camera
@onready var blind: CanvasLayer = %blind
@onready var skill_display: TextureRect = %skill_display
@onready var skill_container: Panel = %skill_container
@onready var skill_depleted :Label = %skill_depleted
@onready var no_skill: bool = false

const pop_normal : PackedScene = preload("res://scenes/pop_question_normal.tscn")
const orb : PackedScene = preload("res://scenes/orb.tscn")
const result_scn : PackedScene = preload("res://scenes/results.tscn")
const change_realm : PackedScene = preload("res://scenes/vacation.tscn")

@export var shape_positionY = 80
@export var shape_positionX = 80
@export var size_x :int= 160
@export var size_y :int= 160

@onready var trap = traps.new()
var rng = RandomNumberGenerator.new()
var no_orbs = global_var.questions_arr.size()
var orbs_temp_list=[]
var area_2d_points :Array= []
var no_wrong : int = 0
var no_correct : int = 0
var result_question:String
var right_answers = []
var wrong_answers = []
var noorbs :int= global_var.questions_arr.size()
var tween :Tween= create_tween()
var active_barrier: bool
var press_s : bool = false

@onready var maze_fin:bool = false
@onready var wall_fin: bool = false

signal wall_done
signal show_skills

func _ready():
	tween.stop()
	skills_display()
	no_orb_dis.text = str(noorbs)
	AreaResize_RelativetoOrb()
	put_temporary()
	area_wall_offset()
	set_wall()
	Tilemaplayer.connect("maze_finished", instance_orb)
	Tilemaplayer.connect("maze_finished", func(): 
		maze_fin = true)
	self.connect("wall_done", func():
		wall_fin = true)

func _process(_delta: float) -> void:
	loading_hide()
	if !no_skill:
		if Input.is_action_just_pressed("skill"):
			if press_s:
				reset_tween()
				press_s = false
				active_skill()
				tween.tween_property(skill_container, "position", Vector2(1200, 118), 1)

func press_i_pop_up():
	randomize()
	var index = global_var.access_random_num_on_question(no_q.size())
	var new_question = pop_normal.instantiate()
	new_question.index = index
	container_popup.add_child(new_question)
	if !global_var.questions_arr[index].contains("IsImagePath"):
		result_question = global_var.questions_arr[index]
	if global_var.questions_arr[index].contains("IsImagePath"):
		result_question = global_var.questions_arr[index]
		result_question.substr(12,-1)
	new_question.connect("orb_free", remove_nearest_orb)
	new_question.connect("right", right_increment)
	new_question.connect("wrong", wrong_increment)

func pop_up_has_childsp() -> bool:
	var child := container_popup.get_children()
	var check :bool= false
	if child.size() > 0:
		check = false
	else:
		check = false
	return check

func remove_nearest_orb():
	#orb templist is the reference of orb instances in orbs container
	for orbs in orbs_temp_list:
		if orbs != null:
			if orbs is Node2D:
				orbs.in_region_orb_remove()
			else:
				pass
		else:
			pass

func AreaResize_RelativetoOrb():
	spawner_area.shape.size.x = size_x
	spawner_area.shape.size.y = size_y
	var area_x:int= spawner_area.shape.size.x
	var area_y:int= spawner_area.shape.size.y
	var no_questions:int= global_var.questions_arr.size()
	if no_questions > 8:
		no_questions = 8
	var no_even :int
	if no_questions % 2 == 0:
		no_even  = no_questions + 1
	else:
		no_even = no_questions
	if no_questions >= 0:
		spawner_area.shape.size.x = area_x * no_even
		spawner_area.shape.size.y = area_y * no_even
	else:
		pass

func area_wall_offset():
	#offsets the area or the collision shap naped spawner area o the quadrant 4
	spawn_area_shape.position.x = shape_positionX
	spawn_area_shape.position.y = shape_positionY
	if spawner_area is CollisionShape2D:
		if spawner_area.shape.size.x != 0 && spawner_area.shape.size.y != 0:
			var shapeX = spawner_area.shape.size.x/2
			var shapeY = spawner_area.shape.size.x/2
			spawner_area.position.x = shapeX - shape_positionX
			spawner_area.position.y = shapeY -shape_positionY
			#print(spawner_area.shape.size)
			#print(spawner_area.position)	
		else:
			print("not offset")

func set_wall():
	var coord_shapeX :int= spawner_area.shape.size.x / 32
	var coord_shapeY :int= spawner_area.shape.size.y / 32
	var finished:bool= false
	var up_side:bool= true
	var right_side:bool= true
	var down_side:bool= true
	var left_side:bool= true
	var coords :Vector2i =Vector2i(-1,-1)
	#Tilemaplayer.set_cell(coords, 1,Vector2i(0,0),0)
	while !finished:
	# set walls for every sides of the area
		if up_side:
			#iterates from (0,0 to the coordinate of x area (x,0)
			for coord1 in range(coord_shapeX + 2):
				#add 2 to add more walls (kinulang)
				#loops though the (0,0 to (x,0) and place a walll
				Tilemaplayer.set_cell(coords, 1,Vector2i(0,0),0)
				coords.x = coords.x+1
				await get_tree().create_timer(0.1).timeout
			coords=Vector2i(coord_shapeX,0)
			up_side = false
			
		if right_side:
			for coord2 in range(coord_shapeY):
				Tilemaplayer.set_cell(coords, 1,Vector2i(0,0),0)
				coords.y = coords.y+1
				await get_tree().create_timer(0.1).timeout
			coords=Vector2i(0,coord_shapeY)
			right_side = false
			
		if down_side:
			for coord2 in range(coord_shapeY + 1) :
				Tilemaplayer.set_cell(coords, 1,Vector2i(0,0),0)
				coords.x = coords.x+1
				await get_tree().create_timer(0.1).timeout
			coords=Vector2i(-1,0)
			down_side = false
			
		if left_side:
			for coord2 in range(coord_shapeY + 1 ):
				Tilemaplayer.set_cell(coords, 1,Vector2i(0,0),0)
				coords.y = coords.y+1
				await get_tree().create_timer(0.1).timeout
			left_side = false
		finished = true
		break
	wall_done.emit()

func instance_orb():
	var positions_ofOrbs : Array = Tilemaplayer.orb_places
	#pxl cell is the number of pixel size of each cell
	var pixl_cell : Vector2 = Vector2(32,32)
	for n in no_orbs:
		randomize()
		var r = randi_range(0,positions_ofOrbs.size()-1)
		var orb_instance = orb.instantiate()
		orbs_container.add_child(orb_instance)
		orbs_temp_list.append(orb_instance)
		orb_instance.position = (positions_ofOrbs[r] * pixl_cell) + Vector2(16, 16)
		orb_instance.connect("press_I" , display_press_I)
		orb_instance.connect("unpress_I" , undisplay_press_I)
		for x in range(20):
			if orb_instance.orb_detector.has_overlapping_areas():
		#multiply the position to the pixel cell, referencing to the coordinate of the tile map
		# add vector(16,16) to center the orb 32/2
				orb_instance.position = (positions_ofOrbs[r] * pixl_cell) + Vector2(16, 16)
			else: 
				break
		positions_ofOrbs.erase(positions_ofOrbs[r])
		orb_instance.connect("area_entered", press_i_pop_up)

func right_increment():
	no_correct = no_correct + 1
	noorbs = noorbs - 1
	no_orb_dis.text = str(noorbs)
	correct.text = str(no_correct)
	right_answers.append(result_question)
	animation_emote.play("animate_right")

func wrong_increment():
	no_wrong = no_wrong + 1
	noorbs = noorbs - 1
	no_orb_dis.text = str(noorbs)
	wrong.text = str(no_wrong)
	wrong_answers.append(result_question)
	animation_emote.play("animate_wrong")
	if !active_barrier:
		traps_triggered(false)
		await get_tree().create_timer(6).timeout
		traps_triggered(true)

func _on_settings_pressed() -> void:
	setting_pop.process_mode = Node.PROCESS_MODE_ALWAYS
	setting_pop.visible = true
	get_tree().paused = true

func _on_cancel_pressed() -> void:
	setting_pop.process_mode = Node.PROCESS_MODE_DISABLED
	setting_pop.visible = false
	get_tree().paused = false

func _on_return_pressed() -> void:
	get_tree().paused = false
	flashcards.minutes = 0
	flashcards.seconds = 0
	global_var.questions_arr = []
	global_var.answer_arr = []
	global_var.temp_answer_arr = []
	global_var.temp_questions_arr =[]
	global_var.user_answer = {}
	global_var.ImageAndLabel = {}
	DFS.orb_places = []
	get_tree().change_scene_to_file("res://scenes/loading_to_main.tscn")

func _on_edit_pressed() -> void:
	global_var.questions_arr = []
	global_var.answer_arr = []
	global_var.user_answer = {}
	DFS.orb_places = []
	get_tree().paused = false
	flashcards.edit = true
	get_tree().change_scene_to_file("res://scenes/questions_scene.tscn")

func put_temporary():
	for n in global_var.answer_arr:
		global_var.temp_answer_arr.append(n)
	for n in global_var.questions_arr:
		global_var.temp_questions_arr.append(n)

func _on_timer_timesup() -> void:
	Result.right_question_res = right_answers
	Result.wrong_question_res = wrong_answers
	animation_result.play("result_label_pan")
	get_tree().paused = true
	await get_tree().create_timer(3).timeout
	var res= result_scn.instantiate()
	results_display.add_child(res)
	results_display.move_child(res, 0)
	res.connect("reset", reset_all)

func display_press_I() -> void:
	interact_label.text ="Press \"I\" to interact"
	
func undisplay_press_I() -> void:
	interact_label.text =""

func loading_hide():
	if wall_fin && maze_fin:
		wall_fin = false
		maze_fin = false
		loading.visible = false
		await get_tree().create_timer(2).timeout
		camera.play("pan_in_cam")
		await get_tree().create_timer(2).timeout
		character.process_mode = Node.PROCESS_MODE_INHERIT
		loading.process_mode = Node.PROCESS_MODE_DISABLED
		timer.process_mode = Node.PROCESS_MODE_INHERIT
		timer.visible = true
		press_s = true
		show_skills.emit()

func traps_triggered(reset: bool):
	if !reset:
		blind.process_mode=Node.PROCESS_MODE_INHERIT
		blind.visible = true
		cam.zoom = Vector2(9.0,9.0)
		character.max_speed = 50
	elif reset:
		blind.process_mode=Node.PROCESS_MODE_DISABLED
		blind.visible = false
		cam.zoom = Vector2(3.0, 3.0)
		character.max_speed = 200

func skills_display():
	var S_texture
	if global_var.Angelboots:
		S_texture= load("res://assets/Image_assets/buttons/Skill_3_BootsofHermes.png")
		skill_display.texture = S_texture
	elif global_var.Godeye:
		S_texture= load("res://assets/Image_assets/buttons/Skill_1_God'sEye.png")
		skill_display.texture = S_texture
	elif global_var.Shield:
		S_texture= load("res://assets/Image_assets/buttons/Skill_2_Barrier.png")
		skill_display.texture = S_texture
	elif global_var.Seaside:
		S_texture = load("res://assets/Image_assets/buttons/Skill_4_SeaSide.png")
		skill_display.texture = S_texture
	else:
		no_skill = true

func _on_show_skills() -> void:
	if !no_skill:
		reset_tween()
		tween.play()
		tween.tween_property(skill_container, "position", Vector2(1040, 118), 1)

func active_skill() -> void:
	if global_var.Godeye:
		character.eye_zoom(cam, true)
		await get_tree().create_timer(10).timeout
		character.eye_zoom(cam, false)
	elif global_var.Angelboots:
		character.speed_boots(true)
		await get_tree().create_timer(20).timeout
		character.speed_boots(false)
	elif global_var.Shield:
		active_barrier = character.shield(true)
		await get_tree().create_timer(60).timeout
		active_barrier = character.shield(false)
	elif global_var.Seaside:
		get_tree().change_scene_to_packed(change_realm)
	if !global_var.Seaside:
		skill_depleted.visible = true
		await get_tree().create_timer(2).timeout
		skill_depleted.visible = false
	
func reset_tween():
	if tween:
		tween.kill()
	tween = create_tween()

func reset_all():
	global_var.questions_arr = []
	global_var.answer_arr = []
	global_var.user_answer = {}
	DFS.orb_places = []
	get_tree().paused = false
	flashcards.edit = true
	get_tree().change_scene_to_file("res://scenes/questions_scene.tscn")
