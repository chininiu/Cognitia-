extends Control

@onready var logo:=%logo
@onready var text:=%text
@onready var animation_1= %animation_1
@onready var fade_out= %animation_2 
@onready var animation_3 = %animation_3

signal finished

func _ready():

	fade_out.play("fade_out")
	animation_3.play("animation_title")
	await get_tree().create_timer(2).timeout
	animation_1.play("animation_logo")
	await get_tree().create_timer(1).timeout
	fade_out.play_backwards("fade_out")
	await get_tree().create_timer(5).timeout
	finished.emit()

		
	
