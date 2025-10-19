extends CanvasLayer

@onready var total: Label = $VBoxContainer/TotalGames/total
@onready var hull: Label = $VBoxContainer/StartingHull/hull
@onready var shield: Label = $VBoxContainer/StartingShield/shield
@onready var rof: Label = $VBoxContainer/StartingROF/rof
@onready var delay: Label = $VBoxContainer/StartingDelay/delay
@onready var recharge: Label = $VBoxContainer/StartingRecharge/recharge
@onready var popup: Popup = $VBoxContainer/Popup
@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog

@export var player: Player

signal back_button_pressed


func _ready() -> void:
	_load_vals()


func _on_visibility_changed() -> void:
	if visible:
		_load_vals()


func _load_vals():
	total.text = str(player.total_games)
	hull.text = str(player.start_health)
	shield.text = str(player.start_shield)
	rof.text = str(player.start_rof)
	delay.text = str(player.shield_recharge_delay)
	recharge.text = str(player.start_shield_recharge_time)


func _on_back_button_pressed() -> void:
	emit_signal("back_button_pressed")


func _on_reset_button_pressed() -> void:
	#probably should do a popup... are you sure
	# toggles for progress & highscores?
	# ignore games played?
	# need to save defaults... manually setting them here seems silly
	# could just delete the save files and reload xD
	popup.visible = true
	pass # Replace with function body.


func _on_reset_back_button_pressed() -> void:
	popup.visible = false


func _on_reset_progress_pressed() -> void:
	_confirm_reset(FileManager.PROGRESS_FILE)


func _on_reset_highscores_pressed() -> void:
	_confirm_reset(FileManager.HIGHSCORE_FILE)


func _confirm_reset(s):
	var st = ""
	if s == FileManager.PROGRESS_FILE:
		st = "Are you sure you want to reset Player Progress?" 
	elif s == FileManager.HIGHSCORE_FILE:
		st = "Are you sure you want to reset Highscores?" 
	confirmation_dialog.dialog_text = st
	confirmation_dialog.confirmed.connect(_reset.bind(s))
	confirmation_dialog.canceled.connect(_cancel)
	confirmation_dialog.visible = true


func _reset(s):
	var f = FileAccess.open(s, FileAccess.WRITE)
	#print_debug(DirAccess.remove_absolute(s))
	if s == FileManager.PROGRESS_FILE:
		f.store_var(FileManager.PROGRESS_DEFAULT)
		f = FileAccess.open(FileManager.UPGRADE_FILE, FileAccess.WRITE)
		f.store_var(FileManager.UPGRADES_DEFAULT)
	else:
		f.store_var(FileManager.HIGHSCORE_DEFAULT)
		#print_debug(DirAccess.remove_absolute(FileManager.UPGRADE_FILE))
		
	confirmation_dialog.visible = false
	_disconnect()

func _cancel():
	confirmation_dialog.visible = false
	_disconnect()


func _disconnect():
	confirmation_dialog.canceled.disconnect(_cancel)
	confirmation_dialog.canceled.disconnect(_reset)
	
