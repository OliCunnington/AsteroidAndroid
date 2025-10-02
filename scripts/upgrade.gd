extends Node2D

signal upgrade_collected


func _ready():
	pass


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Player:
		emit_signal("upgrade_collected")
		queue_free()
