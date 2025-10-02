extends CanvasLayer

signal shield
signal shield_delay
signal shield_recharge
signal hull
signal rate_of_fire

@onready var v_box_container = $VBoxContainer
@onready var control_delay = $VBoxContainer/Control4
@onready var control_recharge = $VBoxContainer/Control5


func _ready():
	#var screen_size = get_tree().root.get_visible_rect().size
	#v_box_container.position = Vector2(screen_size.x / 2, screen_size.y/2)
	pass


func _on_rate_of_fire_pressed():
	emit_signal("rate_of_fire")


func _on_hull_pressed():
	emit_signal("hull")


func _on_shield_pressed():
	emit_signal("shield")


func _on_shield_recharge_pressed():
	emit_signal("shield_recharge")


func _on_shield_delay_pressed():
	emit_signal("shield_delay")


func init(shields: bool):
		control_delay.visible = shields
		control_recharge.visible = shields
