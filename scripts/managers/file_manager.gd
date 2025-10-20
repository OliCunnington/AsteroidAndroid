extends Node

const HIGHSCORE_FILE = "user://highscores.save"
const SETTINGS_FILE = "user://settings.save"
const PROGRESS_FILE = "user://progress.save"
const UPGRADE_FILE = "user://upgrades.save"


const HIGHSCORE_DEFAULT = [
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
		{"name": "-","date": "-","score": -1,"color": "#000000"},
	]

const PROGRESS_DEFAULT = {
		"hull" : 1,
		"shield" : 0,
		"rof" : 0.75,
		"recharge_time" : 5.0,
		"recharge_delay" : 10.0,
		"total_score" : 0,
		"total_games" : 0
	}
const UPGRADES_DEFAULT = {
		"shield" : 10,
		"hull" : 10,
		"rof" : 10,
		"delay" : 10,
		"recharge" : 10
	}
