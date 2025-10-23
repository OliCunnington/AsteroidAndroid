extends HBoxContainer
class_name HighscorePanel

@onready var name_label = $Name
@onready var score = $Score
@onready var date = $Date
@onready var text_color = "ffffff"


func _set_score(_name, _score, _date, _color):
	name_label.text = _name
	score.text = str(_score)
	date.text = _date
	name_label.self_modulate = _color
	score.self_modulate = _color
	date.self_modulate = _color


func set_score(in_name, in_score, color):
	if in_name.length() > 8:
		in_name = "%s%s" % [in_name.substr(0, 8) , "*"]
	_set_score(in_name, in_score, Time.get_datetime_string_from_system(false, true), color)


func set_from_score_val(score_val):
	_set_score(score_val.name, score_val.score, score_val.date, score_val.color)


func get_score():
	return int(score.text)


func get_score_val():
	var val = ScoreVal.new()
	val.name = name_label.text
	val.date = date.text
	val.score = int(score.text)
	val.color = text_color
	return val
