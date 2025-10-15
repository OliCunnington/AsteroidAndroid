extends CanvasLayer

@onready var total: Label = $VBoxContainer/TotalGames/total
@onready var hull: Label = $VBoxContainer/StartingHull/hull
@onready var shield: Label = $VBoxContainer/StartingShield/shield
@onready var rof: Label = $VBoxContainer/StartingROF/rof
@onready var delay: Label = $VBoxContainer/StartingDelay/delay
@onready var recharge: Label = $VBoxContainer/StartingRecharge/recharge

@export var player: Player
# Called when the node enters the scene tree for the first time.
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
