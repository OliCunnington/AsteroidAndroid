extends CanvasLayer

@export var player : Player

@onready var label: Label = $Label
@onready var shield_price_label: Label = $VBoxContainer/Control/PriceLabel
@onready var hull_price_label: Label = $VBoxContainer/Control2/PriceLabel
@onready var rof_price_label: Label = $VBoxContainer/Control3/PriceLabel
@onready var delay_price_label: Label = $VBoxContainer/Control4/PriceLabel
@onready var recharge_price_label: Label = $VBoxContainer/Control5/PriceLabel

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
	if _purchase(shield_price_label):
		player.start_shield += 1


func _on_hull_pressed() -> void:
	if _purchase(hull_price_label):
		player.start_health += 1


func _on_rate_of_fire_pressed() -> void:
	if _purchase(rof_price_label):
		player.start_rof *= 0.9


func _on_shield_delay_pressed() -> void:
	if _purchase(delay_price_label):
		player.start_shield_recharge_delay *= 0.9


func _on_shield_recharge_pressed() -> void:
	if _purchase(recharge_price_label):
		player.start_shield_recharge_time *= 0.9


func _on_visibility_changed() -> void:
	if visible:
		_update_label()


func _update_label():
	label.text = str(player.get_score())


func _check_balanance(price) -> bool:
	return price <= player.get_score()


func _purchase(label):
	var p = int(label.text)
	if _check_balanance(p):
		player.change_score(-p)
		label.text = str(p*2) 
		_update_label()
		return true
	else:
		return false
