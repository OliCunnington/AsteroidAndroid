extends CharacterBody2D
class_name Player

@export var bullet_scene :  PackedScene 
@export var speed := 600
@export var rotation_speed := 4.0 
@export var start_shield = 0
@export var start_health = 1
@export var start_rof = 0.75

@onready var screen_size = get_viewport_rect().size
@onready var animation_player = $AnimationPlayer
@onready var shoot_timer = $ShootTimer
@onready var shield_timer = $ShieldTimer
@onready var shield_recharge_timer = $ShieldRechargeTimer
@onready var boosting_animation = $BoostingAnimation
@onready var turning_animation = $TurningAnimation
@onready var progress_bar = $ProgressBar
@onready var turning_sound: AudioStreamPlayer2D = $TurningSound
@onready var shooting_sound: AudioStreamPlayer2D = $ShootingSound
@onready var engine_sound: AudioStreamPlayer2D = $EngineSound

signal dead
signal shield_damage
signal shield_regained
signal hull_damage

var shield : int
var shield_max : int
var health : int
var rate_of_fire : float = 1.0
var shooting = false
var boosting = false
var rotation_direction := 0.0
var shield_recharge_delay : float = 10.0
var shield_recharge_time : float = 5.0
var total_score : int = 0


func _process(delta):
	handle_audio()
	if shield_timer.time_left > 0:
		progress_bar.self_modulate = "ff00268b"
		progress_bar.visible = true
		progress_bar.max_value = shield_recharge_delay
		progress_bar.value = shield_timer.time_left
	elif shield_recharge_timer.time_left > 0:
		progress_bar.self_modulate = "0087fd8b"
		progress_bar.visible = true
		progress_bar.max_value = shield_recharge_time
		progress_bar.value = shield_recharge_time - shield_recharge_timer.time_left
	else:
		progress_bar.visible = false


func _physics_process(delta):
	velocity = velocity.lerp(transform.y * -1.0 * speed, delta) if boosting else velocity.lerp(Vector2.ZERO, delta)
	rotation += rotation_direction * rotation_speed * delta
	
	move_and_slide()
	screen_wrap()


func _on_shoot_t_button_pressed():
	if not shooting:
		shooting = true
		if shoot_timer.is_stopped():
			shoot()



func _on_shoot_t_button_released():
	shooting = false


func _on_boost_t_button_pressed():
	Input.vibrate_handheld(50)
	boosting = true
	boosting_animation.visible = true


func _on_boost_t_button_released():
	boosting = false
	boosting_animation.visible = false


func _on_left_t_button_pressed():
	Input.vibrate_handheld(50)
	rotation_direction = -1.0
	turning_animation.visible = true
	turning_animation.flip_h = true


func _on_left_t_button_released():
	rotation_direction = 0.0
	turning_animation.visible = false
	turning_animation.flip_h = false


func _on_right_t_button_pressed():
	Input.vibrate_handheld(50)
	rotation_direction = 1.0
	turning_animation.visible = true


func _on_right_t_button_released():
	rotation_direction = 0.0
	turning_animation.visible = false


func _on_shoot_timer_timeout():
	if shooting: shoot()


func _on_shield_timer_timeout():
	if shield < shield_max:
		#shield += 1
		shield_recharge_timer.start(shield_recharge_time)


func _on_shield_recharge_timer_timeout():
	if shield < shield_max:
		shield += 1
	if shield < shield_max:
		shield_recharge_timer.start(shield_recharge_time)
	emit_signal("shield_regained")


func shoot():
	Input.vibrate_handheld(50)
	shooting_sound.play()
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $BulletSpawn.global_position
	#bullet.speed -= velocity.y #TODO no bien
	bullet.rotation = rotation
	get_parent().add_child(bullet)
	shoot_timer.start(rate_of_fire)


func screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)


func damage():
	
	if !shield_timer.is_stopped():
		shield_timer.stop()
	if !shield_recharge_timer.is_stopped():
		shield_recharge_timer.stop()
		
	if shield > 0: 
		shield -= 1
		emit_signal("shield_damage")
	else: 
		health -= 1
		emit_signal("hull_damage")
	
	if health <= 0: die()
	elif shield_max > 0 and shield < shield_max:
		shield_timer.start(shield_recharge_delay)


func die():
	print("Player died")
	shooting = false
	progress_bar.visible = false
	animation_player.play("die")


func death_signal():
	emit_signal("dead")


func handle_audio():
	if turning_animation.visible and !turning_sound.playing:
		turning_sound.play()
	elif !turning_animation.visible:
		turning_sound.stop()
	if boosting_animation.visible and !engine_sound.playing:
		engine_sound.play()
	elif !boosting_animation.visible:
		engine_sound.stop()
		

func get_score() -> int:
	return total_score


func change_score(s):
	total_score += s
