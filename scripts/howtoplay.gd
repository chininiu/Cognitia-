extends Control

@onready var transition = $transition
@onready var button = %TextureButton

func _ready() -> void:
	transition.play("in")

func _on_texture_button_pressed() -> void:
	transition.play("out")
	await get_tree().create_timer(1.5).timeout
	self.queue_free()
