extends Control

@onready var skills : TextureButton = %skill_button
@onready var character : TextureButton = %characters
@onready var tools : TextureButton = %tools
@onready var click_animation : AnimationPlayer = %click_animation
@onready var total_currency : Label = %total_currency
@onready var buy_1 : Button = %buy_1
@onready var buy_2 : Button = %buy_2
@onready var buy_3 : Button = %buy_3
@onready var buy_4 : Button = %buy_4
@onready var buy_1_access :Button= %buy_1_Acess
@onready var buy_2_access :Button= %buy_2_Access
@onready var buy_3_access :Button= %buy_3_Access
@onready var buy_4_access :Button = %buy_4_Access

var skill_boo : bool = true
var character_boo : bool = false
var tool_boo : bool = false
var tween :Tween= create_tween()
var total_cur : int

func _init() -> void:
	total_cur = global_var.currency

func _ready() -> void:
	tween.stop()
	total_currency.text = str(total_cur)
	click_animation.play("in_animation")
	check_items_bought()
	
func tween_reset() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func _on_skill_button_pressed() -> void:
	tween_reset()
	if skill_boo:
		pass
	elif !skill_boo:
		control_other_buttons(true)
		tween_back()
		trans_between("skills")
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(skills, "position", tween_position(skills), 0.3)
		await tween.finished
		skill_boo = true
		control_other_buttons(false)

func _on_characters_pressed() -> void:
	tween_reset()
	if character_boo:
		pass
	elif !character_boo:
		control_other_buttons(true)
		tween_back()
		trans_between("character")
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(character, "position", tween_position(character), 0.3)
		await tween.finished
		character_boo = true
		control_other_buttons(false)

func _on_tools_pressed() -> void:
	tween_reset()
	if tool_boo:
		pass
	elif !tool_boo:
		control_other_buttons(true)
		tween_back()
		trans_between("tools")
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(tools, "position", tween_position(tools), 0.3)
		await tween.finished
		tool_boo = true
		control_other_buttons(false)

func trans_between(ins : String) -> void:
	if skill_boo:
		click_animation.play("skills_out")
		await click_animation.animation_finished
		skill_boo = false
	elif character_boo:
		click_animation.play("character_out")
		await click_animation.animation_finished
		character_boo = false
	elif tool_boo:
		click_animation.play("tools_out")
		await click_animation.animation_finished
		tool_boo = false
	click_animation.play(ins + "_in")

func tween_back() -> void:
	if skill_boo:
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(skills, "position", tween_position_ret(skills), 0.3)
	elif tool_boo:
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(tools, "position", tween_position_ret(tools), 0.3)
	elif character_boo:
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		tween.tween_property(character, "position", tween_position_ret(character), 0.3)

func tween_position (obj : TextureButton) -> Vector2:
	return Vector2(obj.position.x + 30, obj.position.y)

func tween_position_ret(obj : TextureButton) -> Vector2:
	return Vector2(obj.position.x - 30, obj.position.y)

func control_other_buttons(n : bool) -> void:
	if n:
		if skills != self:
			skills.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if character != self:
			character.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if tools != self:
			tools.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif !n:
		if skills != self:
			skills.mouse_filter = Control.MOUSE_FILTER_STOP
		if character != self:
			character.mouse_filter =  Control.MOUSE_FILTER_STOP
		if tools != self:
			tools.mouse_filter =  Control.MOUSE_FILTER_STOP

func _on_return_button_pressed() -> void:
	click_animation.play("out_anim")
	await click_animation.animation_finished
	self.queue_free()

func check_items_bought():
	if global_var.skill1:
		buy_1.text = "Equip"
		if global_var.Godeye:
			buy_1.text = "Used"
	if global_var.skill2:
		buy_2.text = "Equip"
		if global_var.Shield:
			buy_2.text ="Used"
	if global_var.skill3:
		buy_3.text = "Equip"
		if global_var.Angelboots:
			buy_3.text ="Used"
	if global_var.skill4:
		buy_4.text = "Equip"
		if global_var.Seaside:
			buy_4.text ="Used"
	if global_var.access1:
		buy_1_access.text = "Equip"
		if global_var.demon:
			buy_1_access.text ="Used"
	if global_var.access2:
		buy_2_access.text = "Equip"
		if global_var.angel:
			buy_2_access.text ="Used"
	if global_var.access3:
		buy_3_access.text = "Equip"
		if global_var.thoughts:
			buy_3_access.text ="Used"
	if global_var.access4:
		buy_4_access.text = "Equip"
		if global_var.complementary:
			buy_4_access.text ="Used"

func _on_buy_1_pressed() -> void:
	if global_var.currency >= 50:
		if !global_var.skill1:
			global_var.currency = global_var.currency - 50
			total_currency.text = str(global_var.currency)
			global_var.skill1 = true	
		
	if global_var.skill1:
		global_var.Godeye = true
		global_var.Angelboots = false
		global_var.Shield = false
		global_var.Seaside  = false
		buy_1.text = "Used"
		if global_var.skill2:
			buy_2.text = "Equip"
		if global_var.skill3:
			buy_3.text = "Equip"
		if global_var.skill4:
			buy_4.text = "Equip"

func _on_buy_2_pressed() -> void:
	if global_var.currency >= 25:
		if !global_var.skill2:
			global_var.currency = global_var.currency - 25
			total_currency.text = str(global_var.currency)
			global_var.skill2 = true
			
	if global_var.skill2:
		global_var.Godeye = false
		global_var.Shield = true
		global_var.Angelboots = false
		global_var.Seaside  = false
		buy_2.text = "Used"
		if global_var.skill1:
			buy_1.text = "Equip"
		if global_var.skill3:
			buy_3.text = "Equip"
		if global_var.skill4:
			buy_4.text = "Equip"


func _on_buy_3_pressed() -> void:
	if global_var.currency >= 25:
		if !global_var.skill3:
			global_var.currency = global_var.currency - 25
			total_currency.text = str(global_var.currency)
			global_var.skill3 = true
		
	if global_var.skill3:
		global_var.Godeye = false
		global_var.Shield = false
		global_var.Angelboots = true
		global_var.Seaside  = false
		buy_3.text = "Used"
		if global_var.skill1:
			buy_1.text = "Equip"
		if global_var.skill2:
			buy_2.text = "Equip"
		if global_var.skill4:
			buy_4.text = "Equip"

func _on_buy_4_pressed() -> void:
	if global_var.currency >= 30:
		if !global_var.skill4:
			global_var.currency = global_var.currency - 30
			total_currency.text = str(global_var.currency)
			global_var.skill4 = true
	if global_var.skill4:
		global_var.Godeye = false
		global_var.Shield = false
		global_var.Angelboots = false
		global_var.Seaside  = true
		buy_4.text = "Used"
		if global_var.skill1:
			buy_1.text = "Equip"
		if global_var.skill3:
			buy_3.text = "Equip"
		if global_var.skill2:
			buy_2.text = "Equip"

func _on_buy_1_acess_pressed() -> void:
	if global_var.currency >= 45:
		if !global_var.access1:
			global_var.currency = global_var.currency - 45
			total_currency.text = str(global_var.currency)
			global_var.access1 = true
	if global_var.access1:
		global_var.demon = true
		global_var.angel = false
		global_var.thoughts = false
		global_var.complementary = false
		buy_1_access.text = "Used"
		if global_var.access2:
			buy_2_access.text = "Equip"
		if global_var.access3:
			buy_3_access.text = "Equip"
		if global_var.access4:
			buy_4_access.text = "Equip"

func _on_buy_2_access_pressed() -> void:
	if global_var.currency >= 45:
		if !global_var.access2:
			global_var.currency = global_var.currency - 45
			total_currency.text = str(global_var.currency)
			global_var.access2 = true
	if global_var.access2:
		global_var.demon = false
		global_var.angel = true
		global_var.thoughts = false
		global_var.complementary = false
		buy_2_access.text = "Used"
		if global_var.access1:
			buy_1_access.text = "Equip"
		if global_var.access3:
			buy_3_access.text = "Equip"
		if global_var.access4:
			buy_4_access.text = "Equip"

func _on_buy_3_access_pressed() -> void:
	if global_var.currency >= 25:
		if !global_var.access3:
			global_var.currency = global_var.currency - 25
			total_currency.text = str(global_var.currency)
			global_var.access3 = true
	if global_var.access3:
		global_var.demon = false
		global_var.angel = false
		global_var.thoughts = true
		global_var.complementary = false
		buy_3_access.text = "Used"
		if global_var.access1:
			buy_1_access.text = "Equip"
		if global_var.access2:
			buy_2_access.text = "Equip"
		if global_var.access4:
			buy_4_access.text = "Equip"

func _on_buy_4_access_pressed() -> void:
	if global_var.currency >= 50:
		if !global_var.access4:
			global_var.currency = global_var.currency - 50
			total_currency.text = str(global_var.currency)
			global_var.access4 = true
	if global_var.access4:
		global_var.demon = false
		global_var.angel = false
		global_var.thoughts = false
		global_var.complementary = true
		buy_4_access.text = "Used"
		if global_var.access1:
			buy_1_access.text = "Equip"
		if global_var.access2:
			buy_2_access.text = "Equip"
		if global_var.access3:
			buy_3_access.text = "Equip"

func _on_buy_tool_1_pressed() -> void:
	global_var.currency = global_var.currency - 10
	total_currency.text = str(global_var.currency)
	global_var.no_of_hints = global_var.no_of_hints + 1
