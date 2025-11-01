extends Node

@onready var main_menu = preload("res://scenes/main_menu_ui.tscn")
@onready var question_scene = preload("res://scenes/questions_scene.tscn")
@onready var opening_scene: = %Control
@onready var main_menu_parent = %Main_Menu
@onready var question_scene_parent = %Question_scene
func _ready() -> void:
	get_window().title = "Cognitia"
	if global_var.new:
		opening_scene.connect("finished", func() :
			global_var.new = false
			var instance = main_menu.instantiate() 
			main_menu_parent.add_child(instance)
			instance.connect("maze_active", func():
				var instance2 = question_scene.instantiate()
				main_menu_parent.remove_child(main_menu_parent.get_child(0))
				question_scene_parent.add_child(instance2)
				)
			)
	elif !global_var.new:
		opening_scene.process_mode = Node.PROCESS_MODE_DISABLED
		opening_scene.visible = false
		var instance = main_menu.instantiate() 
		main_menu_parent.add_child(instance)
		instance.connect("maze_active", func():
				var instance2 = question_scene.instantiate()
				main_menu_parent.remove_child(main_menu_parent.get_child(0))
				question_scene_parent.add_child(instance2)
				)
			
