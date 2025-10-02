extends CanvasLayer

signal play_button_pressed
signal about_button_pressed
signal quit_button_pressed
signal highscores_button_pressed
signal settings_button_pressed


func _on_play_button_pressed():
	emit_signal("play_button_pressed")


func _on_about_button_pressed():
	emit_signal("about_button_pressed")


func _on_quit_button_pressed():
	emit_signal("quit_button_pressed")


func _on_highscores_button_pressed():
	emit_signal("highscores_button_pressed")


func _on_settings_button_pressed():
	emit_signal("settings_button_pressed")
