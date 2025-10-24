extends Resource
class_name ScoreVal

var name: String
var date: String
var score: int
var color: Color


func to_dict():
	return {
		"name": name,
		"date": date,
		"score": score,
		"color": color
	}


func from_dict(dict):
	name = dict["name"]
	date = dict["date"]
	score = dict["score"]
	color = dict["color"]
