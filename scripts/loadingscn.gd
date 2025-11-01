extends CanvasLayer

@onready var logo :TextureRect= %logo
var maze_done:bool = false
var wall_done: bool = false

func _process(delta: float) -> void:
	logo.rotation += 2*delta
