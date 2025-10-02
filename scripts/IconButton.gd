extends Sprite2D


signal button_down
signal button_up


func _on_button_pressed():
	emit_signal("button_down")


func _on_button_released():
	emit_signal("button_up")
