extends Control

@onready var img_texture_rect :TextureRect= %question
@onready var label:TextEdit = %label
@onready var add_label: Button = %add_label
var path_image : String
signal has_delete

func _on_file_dialog_file_selected(path: String) -> void:
	var img:Image =Image.new()
	var img_texture = ImageTexture.new()
	img.load(path)
	img_texture.set_image(img)
	img_texture_rect.texture = img_texture
	path_image = path

func _on_open_files_btn_pressed() -> void:
	%FileDialog.popup()

func _on_texture_button_pressed() -> void:
	has_delete.emit()
	self.queue_free()

func _on_add_label_pressed() -> void:
	if img_texture_rect.visible:
		img_texture_rect.visible = false
		label.visible = true
		img_texture_rect.process_mode = Node.PROCESS_MODE_DISABLED
		label.process_mode = Node.PROCESS_MODE_INHERIT
		add_label.text = "Image"
	elif !img_texture_rect.visible:
		img_texture_rect.visible = true
		label.visible = false
		img_texture_rect.process_mode = Node.PROCESS_MODE_INHERIT
		label.process_mode = Node.PROCESS_MODE_DISABLED
		add_label.text = "Add Label"
