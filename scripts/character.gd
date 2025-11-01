extends CharacterBody2D
class_name Cognitia

@export var max_speed :float= 200
@export var friction :float= 1000
@export var accel :float= 600

@onready var run_animation := %run
@onready var idle_animation := %idle
@onready var spirit := %sprite
@onready var collision := %CollisionShape2D
@onready var shield_display = %shield
@onready var corrupted :AnimatedSprite2D= %corrupted
@onready var accessories : Sprite2D = %accessories
var tween = create_tween()

var input = Vector2.ZERO
var back := false
var front := false
var left := false
var right := false
var NE := false
var NW := false
var SE := false
var SW := false

signal get_orb_material

func _ready():
	accessories_active()
	tween.stop()
	idle_animation.play("idle_s")

func _physics_process(delta):
	movement(delta)
	facing()
	animation_movement()
	collision_shift()
	
func collision_shift():
	if spirit.is_flipped_h():
		collision.position.x=3
	else:
		collision.position.x=0
		
func animation_movement():
	var input_direction = get_input()
	state()
	#idle
	if input_direction.y == 0 && front:
		idle_animation.play("idle_s")
	if input_direction.y == 0 && back:
		idle_animation.play("idle_n")
	if input_direction.x == 0 && left:
		idle_animation.play("idle_w")
		spirit.set_flip_h(false)
	if input_direction.x == 0 && right:
		idle_animation.play("idle_w")
		spirit.set_flip_h(true)
	if input_direction == Vector2.ZERO && NE:
		idle_animation.play("idle_nw")
		spirit.set_flip_h(true)
	if input_direction == Vector2.ZERO && NW:
		idle_animation.play("idle_nw")
		spirit.set_flip_h(false)
	if input_direction == Vector2.ZERO && SE:
		idle_animation.play("idle_sw")
		spirit.set_flip_h(true)
	if input_direction == Vector2.ZERO && SW:
		idle_animation.play("idle_sw")
		spirit.set_flip_h(false)
	#run
	if input_direction.y > 0 && input_direction.x == 0:
		run_animation.play("run_s")
	if input_direction.y < 0  && input_direction.x == 0:
		run_animation.play("run_n")
	if input_direction.x < 0 && input_direction.y == 0:
		run_animation.play("run_w")
		spirit.set_flip_h(false)
	if input_direction.x > 0 && input_direction.y == 0:
		run_animation.play("run_w")
		spirit.set_flip_h(true)
	if input_direction.y < 0 && input_direction.x > 0:
		run_animation.play("run_nw")
		spirit.set_flip_h(true)
	if input_direction.y < 0 && input_direction.x < 0:
		run_animation.play("run_nw")
		spirit.set_flip_h(false)
	if input_direction.y > 0 && input_direction.x > 0:
		run_animation.play("run_sw")
		spirit.set_flip_h(true)
	if input_direction.y > 0 && input_direction.x < 0:
		run_animation.play("run_sw")
		spirit.set_flip_h(false)
		
func facing():
	var direction =  get_input()
	if direction.y > 0: 
		front= true
		back = false
		right = false
		left = false
		NE = false
		NW = false
		SE = false
		SW = false
	if direction.y < 0: 
		front= false
		back = true
		right = false
		left = false
		NE = false
		NW = false
		SE = false
		SW = false
	if direction.x < 0: 
		front= false
		back = false
		right = false
		left = true
		NE = false
		NW = false
		SE = false
		SW = false
	if direction.x >  0: 
		front= false
		back = false
		right = true
		left = false
		NE = false
		NW = false
		SE = false
		SW = false
	if direction.y < 0 && direction.x > 0:
		front= false
		back = false
		right = false
		left = false
		NE = true
		NW = false
		SE = false
		SW = false
	if direction.y < 0 && direction.x < 0:
		front= false
		back = false
		right = false
		left = false
		NE = false
		NW = true
		SE = false
		SW = false
	if direction.y > 0 && direction.x < 0:
		front= false
		back = false
		right = false
		left = false
		NE = false
		NW = false
		SE = false
		SW = true
	if direction.y > 0 && direction.x > 0:
		front= false
		back = false
		right = false
		left = false
		NE = false
		NW = false
		SE = true
		SW = false
		
func state():
	if get_input() == Vector2.ZERO:
		run_animation.pause()
		idle_animation.play()
	else:
		run_animation.play()
		idle_animation.pause()
		
func get_input():
	input = Input.get_vector("ui_left" , "ui_right" , "ui_up" , "ui_down" )
	return input
	
func movement(delta):
	
	var user_input = get_input()
	if user_input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction*delta)
		else:
			velocity= Vector2.ZERO
	else:
		velocity += (accel * input * delta)
		velocity = velocity.limit_length(max_speed)
	move_and_slide()

func _on_area_2d_area_entered(_area):
	get_orb_material.emit()

func speed_boots(n : bool):
	if n:
		max_speed = 1000
		accel = 1000
	else:
		max_speed = 200
		accel = 600

func eye_zoom( cam: Camera2D, n: bool):
	tween_reset()
	tween.play()
	if n:
		tween.tween_property(cam, "zoom", Vector2(0.6, 0.6), 1)
	else:
		cam.zoom = Vector2(3.0,3.0)
		tween.stop()
		tween.kill()

func shield(n:bool) -> bool:
	if n:
		shield_display.visible = true
		return true
	elif !n:
		shield_display.visible = false
	return false

func tween_reset() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func accessories_active() -> void:
	if global_var.demon:
		accessories.process_mode = Node.PROCESS_MODE_INHERIT
		accessories.visible = true
		accessories.frame = 0
	elif global_var.angel:
		accessories.process_mode = Node.PROCESS_MODE_INHERIT
		accessories.visible = true
		accessories.frame = 1
	elif global_var.thoughts:
		accessories.process_mode = Node.PROCESS_MODE_INHERIT
		accessories.visible = true
		accessories.frame = 2
	elif global_var.complementary:
		corrupted.process_mode = Node.PROCESS_MODE_INHERIT
		corrupted.play("default", .5, true)
		corrupted.visible= true
