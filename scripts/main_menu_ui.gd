extends Control

@onready var settings : NinePatchRect = %settings

@onready var symbols_des:Label = %symbols_des
@onready var whitespaces_des:Label = %space_des
@onready var typo_des:Label = %typo_des
@onready var autotimer_des:Label = %autotimer_des

@onready var anim_title :AnimationPlayer= %title
@onready var anim_logo :AnimationPlayer = %logo
@onready var transitions :AnimationPlayer = %transitions

@onready var save_back = $settings/save_back

@onready var items_container = preload("res://scenes/items_container.tscn")
@onready var how_to_play = preload("res://scenes/howtoplay.tscn")

@onready var shop :TextureButton = %shop 

signal maze_active

var tween = create_tween()

var direction : Vector2

func _ready() -> void:
	tween.stop()
	anim_title.play("title_animation")
	transitions.play("option_show")
	if 	global_var.auto:	
		%autotimer.button_pressed = true
	if global_var.typo :
		%typo.button_pressed = true
	if global_var.space:
		%white_space.button_pressed = true
	if global_var.symbols:
		%symbols.button_pressed = true

func _on_symbols_toggled(toggled_on_symbols: bool) -> void:
	if toggled_on_symbols:
		symbols_des.visible = true
		global_var.symbols = true
		
	elif !toggled_on_symbols:
		symbols_des.visible = false
		global_var.symbols = false 

func _on_white_space_toggled(toggled_on_space: bool) -> void:
	if toggled_on_space:
		whitespaces_des.visible = true
		global_var.space = true
		
	elif !toggled_on_space:
		whitespaces_des.visible = false
		global_var.space = false

func _on_typo_toggled(toggled_on_typo: bool) -> void:
	if toggled_on_typo:
		typo_des.visible = true
		global_var.typo = true
	elif !toggled_on_typo:
		typo_des.visible = false
		global_var.typo = false

func _on_autotimer_toggled(toggled_on_timer: bool) -> void:
	if toggled_on_timer:
		autotimer_des.visible = true
		global_var.auto = true
	elif !toggled_on_timer:
		autotimer_des.visible = false
		global_var.auto = false

func _on_play_mouse_entered() -> void:
	anim_logo.play("look_down")

func _on_play_mouse_exited() -> void:
	anim_logo.play_backwards("look_down")
	
func _on_option_pressed() -> void:
	transitions.play("option_hide")
	await  get_tree().create_timer(1).timeout
	transitions.play("setting_show")

func _on_save_back_pressed() -> void:
	transitions.play("settings_hide")
	await  get_tree().create_timer(1).timeout
	transitions.play("option_show")

func get_mouse_coords() -> Vector2:
	var coords: Vector2 = get_global_mouse_position() / Vector2(32,32)
	return coords

func _on_play_pressed() -> void:
	transitions.play("option_hide")
	await get_tree().create_timer(1).timeout
	transitions.play("mazeD_show")
	
func _on_return_pressed() -> void:
	transitions.play("mazeD_hide")
	await  get_tree().create_timer(1).timeout
	transitions.play("option_show")

#func set_sprite_cursor():
	#var curr = get_mouse_coords()
	#prev returns to the  InputEventMouseMotion.relative.normlized that gives 4 direction
	# (0,1) bla bla and subtract to the current direction to get the inaacurate prev coordinates
	#var prev :Vector2 = (curr - direction)
	#tile_follow.set_cell( curr, 0, Vector2(0,0), 0)
	#if prev != curr:
			#tile_follow.set_cell( prev, -1, Vector2(0,0), 0)

func _input(event: InputEvent) -> void:
	#returns the direction of the mouse movement
	if event is InputEventMouseMotion:
		var movement = event.relative
		direction = movement.normalized()

func _on_qr_maze_pressed() -> void:
	global_var.qrMaze = true
	global_var.linearMaze = false
	transitions.play("mazeD_hide")
	await  get_tree().create_timer(1.5).timeout
	maze_active.emit()
	
func _on_linear_maze_pressed() -> void:
	global_var.qrMaze = false
	global_var.linearMaze = true
	transitions.play("mazeD_hide")
	await  get_tree().create_timer(1.5).timeout
	maze_active.emit()

func _on_shop_pressed() -> void:
	var item_containerNew = items_container.instantiate()
	await get_tree().process_frame
	self.add_child(item_containerNew)

func _on_shop_mouse_entered() -> void:

	reset_tween()
	tween.tween_property(shop, "position", Vector2(27, 443), .1)
	tween.tween_property(shop,"scale", Vector2(1.6, 1.6), .3 )

	tween.set_trans(Tween.TRANS_ELASTIC)
	await tween.finished

func _on_shop_mouse_exited() -> void:
	reset_tween()
	tween.tween_property(shop, "position", Vector2(27, 453), .1)
	tween.set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	
func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func _on_quit_pressed() -> void:
	global_var.set_values()
	get_tree().quit()

func _on_how_to_play_pressed() -> void:
	var instance = how_to_play.instantiate()
	await get_tree().process_frame
	self.add_child(instance)
