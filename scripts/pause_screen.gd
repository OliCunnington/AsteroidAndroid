extends CanvasLayer

signal resume

@onready var touch_screen_button = $VBoxContainer/ResumeButton


func _ready():
	var screen_size = get_tree().root.get_visible_rect().size
	touch_screen_button.position = Vector2(screen_size.x / 2, screen_size.y/2)


func _on_touch_screen_button_pressed():
	emit_signal("resume")
