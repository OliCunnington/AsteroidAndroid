extends CanvasLayer
class_name SettingsScene

signal settings_back_button_pressed

@onready var menu_banner = $VBoxContainer/MenuBanner
@onready var fullscreen = $VBoxContainer/Fullscreen
@onready var game_banner = $VBoxContainer/GameBanner
@onready var rewarded_on_highscore = $VBoxContainer/RewardedOnHighscore
@onready var rewarded_on_start = $VBoxContainer/RewardedOnStart
#@onready var native_advanced = $VBoxContainer/NativeAdvanced
#@onready var on_open = $VBoxContainer/OnOpen


func _ready():
	
	if FileAccess.file_exists(FileManager.SETTINGS_FILE):
		var file = FileAccess.open(FileManager.SETTINGS_FILE, FileAccess.READ)
		var settings = file.get_var(true)
		#print(settings)
		from_dict(settings)
	
	menu_banner.button_pressed = AdManager.banner_in_menu
	game_banner.button_pressed = AdManager.banner_in_game
	fullscreen.button_pressed = AdManager.fullscreen_after_game
	rewarded_on_highscore.button_pressed = AdManager.rewarded_on_highscore
	rewarded_on_start.button_pressed = AdManager.rewarded_on_start
	#native_advanced.button_pressed = AdManager.native_advanced
	#on_open.button_pressed = AdManager.on_open


func _on_back_button_pressed():
	emit_signal("settings_back_button_pressed")


func _on_menu_banner_toggled(toggled_on):
	AdManager.banner_in_menu = toggled_on


func _on_game_banner_toggled(toggled_on):
	AdManager.banner_in_game = toggled_on


func _on_fullscreen_toggled(toggled_on):
	AdManager.fullscreen_after_game = toggled_on


func _on_rewarded_fullscreen_toggled(toggled_on):
	AdManager.rewarded_on_highscore = toggled_on


func _on_rewarded_on_start_toggled(toggled_on):
	AdManager.rewarded_on_start = toggled_on


func _on_native_advanced_toggled(toggled_on):
	AdManager.native_advanced = toggled_on


func _on_on_open_toggled(toggled_on):
	AdManager.on_open = toggled_on


func to_dict():
	return {
		"menuBanner" : AdManager.banner_in_menu,
		"gameBanner" : AdManager.banner_in_game,
		"fullscreen" : AdManager.fullscreen_after_game,
		"rewarded_on_highscore" : AdManager.rewarded_on_highscore,
		"rewarded_on_start" : AdManager.rewarded_on_start,
		"native_advanced" : AdManager.native_advanced,
		"on_open" : AdManager.on_open
	}


func from_dict(dict):
	AdManager.banner_in_menu = dict["menuBanner"]
	AdManager.banner_in_game = dict["gameBanner"]
	AdManager.fullscreen_after_game = dict["fullscreen"]
	AdManager.rewarded_on_highscore = dict["rewarded_on_highscore"]
	AdManager.rewarded_on_start = dict["rewarded_on_start"]
	AdManager.native_advanced = dict["native_advanced"]
	AdManager.on_open = dict["on_open"]

func _on_tree_exited():
	var file = FileAccess.open(FileManager.SETTINGS_FILE, FileAccess.WRITE)
	file.store_var(to_dict())


func all_off() -> bool:
	var mb = menu_banner.button_pressed
	var gb = game_banner.button_pressed
	var fs = fullscreen.button_pressed
	var roh = rewarded_on_highscore.button_pressed
	var ros = rewarded_on_start.button_pressed
	var a = not mb and not gb and not fs and not roh and not ros
	#print_debug(a, mb, gb, fs, roh, ros)
	return a
