extends CanvasLayer

@onready var label: Label = $VBoxContainer/Label
@onready var timer: Timer = $Timer

@export var text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_set_text")


func _on_timer_timeout() -> void:
	visible = false


func _set_text():
	label.text = text


func _on_visibility_changed() -> void:
	if visible and timer:
		timer.start()


func set_tip(s):
	label.text = s
