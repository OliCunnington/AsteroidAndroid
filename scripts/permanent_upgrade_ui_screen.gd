extends CanvasLayer

@export var player : Player

@onready var label: Label = $Label

signal exit_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	emit_signal("exit_pressed")


func _on_shield_pressed() -> void:
	pass # Replace with function body.


func _on_hull_pressed() -> void:
	pass # Replace with function body.


func _on_rate_of_fire_pressed() -> void:
	pass # Replace with function body.


func _on_shield_delay_pressed() -> void:
	pass # Replace with function body.


func _on_shield_recharge_pressed() -> void:
	pass # Replace with function body.


func _on_visibility_changed() -> void:
	if visible:
		label.text = str(player.get_score())


func _check_balanance(price) -> bool:
	return price <= player.get_score()


func _purchase(control):
	var p = int(control.PriceLabel.text)
	player.change_score(-p)
	control.PriceLabel.text = str(p*2) 
	#emit signal?
