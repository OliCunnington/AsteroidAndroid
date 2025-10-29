extends CanvasLayer


@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var tooltip: CanvasLayer = $Tooltip

@export var settings : SettingsScene

signal play_button_pressed
signal about_button_pressed
signal quit_button_pressed
signal highscores_button_pressed
signal settings_button_pressed
signal upgrades_button_pressed
signal profile_button_pressed


func _ready():
	call_deferred("_settings_check")


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


func _on_upgrades_button_pressed() -> void:
	emit_signal("upgrades_button_pressed")


func _on_profile_button_pressed() -> void:
	emit_signal("profile_button_pressed")


func _on_visibility_changed() -> void:
	if visible:
		_settings_check()


func _settings_check():
	if settings.all_off():
		settings_button.modulate = Color.YELLOW
	else:
		settings_button.modulate = Color.WHITE


func _on_button_pressed() -> void:
	tooltip.set_tip("Spend your total score on permanent upgrades")
	tooltip.visible = true
