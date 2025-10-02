extends CharacterBody2D
class_name Bullet

@export var speed := 900
@export var time_to_live := 3.0

var time_alive = 0.0


func _physics_process(delta):
	position += transform.y * -speed * delta
	time_alive += delta
	if time_alive >= time_to_live:
		queue_free()
