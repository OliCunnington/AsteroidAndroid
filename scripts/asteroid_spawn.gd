extends Control


@export var _asteroid : PackedScene = preload("res://scenes/asteroid.tscn")
@export var emission_dir : Vector2


@onready var player = $"../../Player"
@onready var timer = $Timer
@onready var asteroid_layer = $"../../AsteroidLayer"
@onready var main = $"../.."

var rotation_offset_amout := 1


func _ready():
	timer.start(randi_range(1, 3))


func _on_timer_timeout():
	spawn()
	timer.start(randi_range(1, 3))
	
	
func spawn():
	if !player or !player.visible: return #TODO make this a var set by main scene... todo bien...
	if asteroid_layer.get_child_count() > 10: return
	
	var asteroid = _asteroid.instantiate()
	var direction = emission_dir.rotated(randf_range(-rotation_offset_amout, rotation_offset_amout))
	
	asteroid.global_position = global_position
	asteroid.set_direction(direction)
	asteroid.main = main
	asteroid.connect("destroyed", main.inc_score)
	asteroid_layer.add_child(asteroid)
