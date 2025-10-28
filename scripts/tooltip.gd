extends Panel

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer

@export var text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_set_text")


func _on_timer_timeout() -> void:
	queue_free()


func _set_text():
	label.text = text
