extends CanvasLayer

@onready var highscores_container = $MarginContainer/Panel/MarginContainer/VBoxContainer2
@onready var highscores = $MarginContainer/Panel/MarginContainer/VBoxContainer2/VBoxContainer
@onready var name_input = $MarginContainer/Panel/MarginContainer/VBoxContainer/LineEdit
@onready var new_highscore = $MarginContainer/Panel/MarginContainer/VBoxContainer

var last_score : int
var values : Array[ScoreVal]
var color = Color.WHITE

signal back_button_pressed


func _ready():
	print("ready called")
	_load()


func _on_backbutton_pressed():
	emit_signal("back_button_pressed")


func _on_touch_screen_button_pressed():
	highscores.get_child(highscores.get_child_count() - 1).set_score(name_input.text, last_score)
	sort_scores()
	highscores_container.visible = true
	new_highscore.visible = false


func check_score(score):
	if score >= highscores.get_child(highscores.get_child_count() - 1).get_score():
		if AdManager.rewarded_on_highscore:
			var cp = ColorPicker.new()
			add_child(cp)
			cp.color_changed.connect(func (c):
				remove_child(cp)
				color = c
			)
		else:
			color = Color.WHITE
		last_score = score
		highscores_container.visible = false
		new_highscore.visible = true


func sort_scores():
	var _values : Array[ScoreVal]
	
	for score in highscores.get_children():
		_values.append(score.get_score_val())
	
	_values.sort_custom(func(a, b): return a.score > b.score)
	
	values = _values
	save_scores()
	load_scores()


func save_scores():
	var file = FileAccess.open(FileManager.HIGHSCORE_FILE, FileAccess.WRITE)
	var dict = []
	for val in values:
		dict.append(val.to_dict())
	print(dict)
	file.store_var(dict)


func load_scores():
	for i in range(values.size()):
		highscores.get_child(i).set_from_score_val(values[i])


func _load():
	values = []
	if FileAccess.file_exists(FileManager.HIGHSCORE_FILE):
		var file = FileAccess.open(FileManager.HIGHSCORE_FILE, FileAccess.READ)
		var temp_vals = file.get_var(true)
		for val in temp_vals:
			var score_val = ScoreVal.new()
			score_val.from_dict(val)
			values.append(score_val)
		print(values)
		load_scores()


func _on_visibility_changed() -> void:
	if visible:
		_load()
