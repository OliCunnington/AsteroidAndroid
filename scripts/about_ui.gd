extends CanvasLayer

signal back_button_pressed
signal settings_pressed


func _on_back_button_pressed():
	emit_signal("back_button_pressed")


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	print_debug("click, " + meta)
	if str(meta) == "ad_settings":
		emit_signal("settings_pressed")
	if str(meta) == "kofi":
		OS.shell_open("https://ko-fi.com/scimok")
