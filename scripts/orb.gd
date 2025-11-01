extends StaticBody2D

@onready var animation = %Animation
@onready var orb_detector:Area2D = %orb_detector
@onready var check_if_near = %Area2D
var in_region :bool = false
signal area_entered
signal press_I
signal unpress_I

func _ready():
	animation.play("orb_animation");

func _process(_delta):
	if Input.is_action_just_pressed("I") && in_region:
		global_var.currency += 1 
		emit_signal("area_entered")

func _on_area_2d_body_entered(_body):
	press_I.emit()
	in_region = true
	
func _on_area_2d_body_exited(_body):
	#label.text = ""
	unpress_I.emit()
	in_region = false

func in_region_orb_remove():
	if in_region:
		self.queue_free()
	else:
		pass
