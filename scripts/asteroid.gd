extends RigidBody2D
class_name Asteroid

const ASTEROID := [preload("res://assets/asteroid1.png"),
		preload("res://assets/asteroid2.png"),
		preload("res://assets/asteroid3.png"),
		preload("res://assets/asteroid4.png"),
		preload("res://assets/asteroid5.png")
	]

signal destroyed

@export var upgrade_scene : PackedScene

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var destruction_sound_player: AudioStreamPlayer = $DestructionSoundPlayer

var speed: int
var rotation_speed: int
var direction: Vector2
var screen_size: Vector2
var main: Node2D


func _ready():
	speed = randi_range(75, 250)
	rotation_speed = randf_range(-2.0, 2.0)
	var temp = randf_range(0.75, 1.25)
	scale = Vector2(temp, temp)
	sprite_2d.texture = ASTEROID[randf_range(0, ASTEROID.size() - 1)]


func _process(delta):
	pass


func play_sound():
	print_debug("Playing destruction")
	destruction_sound_player.play()
	destruction_sound_player.finished.connect(finished_playing)

func finished_playing():
	print_debug("finished playing")


func _physics_process(delta):
	rotation += rotation_speed * delta
	var collision = move_and_collide(direction * delta * speed)
	if collision:
		direction = direction.bounce(collision.get_normal())


func _on_area_2d_body_entered(body):
	if body is Bullet:
		animation_player.play("death")
		body.queue_free()
	if body is Player:
		body.damage()


func set_direction(direction):
	self.direction = direction.normalized()


func fire_signal():
	if randi_range(1, 100) >= 75:
		var upgrade = upgrade_scene.instantiate()
		upgrade.position = position
		upgrade.connect("upgrade_collected", main.upgrade_collected)
		get_tree().root.add_child(upgrade)
	collision_shape_2d.disabled = true
	emit_signal("destroyed")


func _on_destruction_sound_player_finished() -> void:
	print_debug("- sound finished")
