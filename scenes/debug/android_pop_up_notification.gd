extends Panel

@onready var label = $VBoxContainer/Label


func init(string : String):
	label.text = string
	size = label.size + Vector2(32,32)
	position = get_viewport_rect().size / 2


func _on_button_pressed():
	queue_free()
