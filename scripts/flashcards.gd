extends Control
signal has_delete

func _ready() -> void:
	pass
func _on_delete_button_pressed():
	has_delete.emit()
	self.queue_free()
