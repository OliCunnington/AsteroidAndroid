extends CanvasLayer

signal shoot_button_pressed
signal shoot_button_release
signal boost_button_pressed
signal boost_button_release
signal left_button_pressed
signal left_button_release
signal right_button_pressed
signal right_button_release
signal pause

@onready var label = $Control2/Label
@onready var hull_indicator = $Control/VBoxContainer/HullIndicator
@onready var shield_indicator = $Control/VBoxContainer/ShieldIndicator


func _on_shoot_t_button_pressed():
	emit_signal("shoot_button_pressed")


func _on_shoot_t_button_released():
	emit_signal("shoot_button_release")


func _on_boost_t_button_pressed():
	emit_signal("boost_button_pressed")


func _on_boost_t_button_released():
	emit_signal("boost_button_release")


func _on_left_t_button_pressed():
	emit_signal("left_button_pressed")


func _on_left_t_button_released():
	emit_signal("left_button_release")


func _on_right_t_button_pressed():
	emit_signal("right_button_pressed")


func _on_right_t_button_released():
	emit_signal("right_button_release")


func set_score_text(score):
	label.text = str(score)


func set_hull_health(hull):
	if hull_indicator and hull_indicator.get_child_count() > 0:
		for child in hull_indicator.get_children():
			child.queue_free()
	for i in range(hull):
		hull_indicator.add_child(hull_indicator.hull_icon.instantiate())


func set_shield_health(shield):
	for child in shield_indicator.get_children():
		child.queue_free()
	for i in range(shield):
		shield_indicator.add_child(shield_indicator.shield_icon.instantiate())


func _on_pause_button_pressed():
	emit_signal("pause")
