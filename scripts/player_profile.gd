extends CanvasLayer

@onready var total: Label = $VBoxContainer/TotalGames/total
@onready var hull: Label = $VBoxContainer/StartingHull/hull
@onready var shield: Label = $VBoxContainer/StartingShield/shield
@onready var rof: Label = $VBoxContainer/StartingROF/rof
@onready var delay: Label = $VBoxContainer/StartingDelay/delay
@onready var recharge: Label = $VBoxContainer/StartingRecharge/recharge
@onready var popup: Popup = $VBoxContainer/Popup

@export var player: Player

signal back_button_pressed


func _ready() -> void:
	_load_vals()


func _on_visibility_changed() -> void:
	if visible:
		_load_vals()


func _load_vals():
	total.text = str(player.total_games)
	hull.text = str(player.start_health)
	shield.text = str(player.start_shield)
	rof.text = str(player.start_rof)
	delay.text = str(player.shield_recharge_delay)
	recharge.text = str(player.start_shield_recharge_time)


func _on_back_button_pressed() -> void:
	emit_signal("back_button_pressed")


func _on_reset_button_pressed() -> void:
	#probably should do a popup... are you sure
	# toggles for progress & highscores?
	# ignore games played?
	# need to save defaults... manually setting them here seems silly
	# could just delete the save files and reload xD
	popup.visible = true
	pass # Replace with function body.


func _on_reset_back_button_pressed() -> void:
	popup.visible = false


func _on_reset_progress_pressed() -> void:
	pass # Replace with function body.


func _on_reset_highscores_pressed() -> void:
	pass # Replace with function body.
