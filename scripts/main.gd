extends Node2D

@export var notification_yoke : PackedScene

@onready var color_rect = $ColorRect
@onready var screen_size = get_viewport_rect().size
@onready var ui = $UI
@onready var menu = $Menu
@onready var about = $About
@onready var highscores = $Highscores
@onready var pause_screen = $PauseScreen
@onready var upgrade_screen = $UpgradeScreen
@onready var settings = $Settings
@onready var player = $Player
@onready var permanent_upgrade_screen = $PermanentUpgradeScreen
@onready var play_area_collider = $Boundaries/Control/PlayArea/PlayAreaCollider
@onready var end_game_sound: AudioStreamPlayer = $EndGameSound
@onready var start_game_sound: AudioStreamPlayer = $StartGameSound

var score : int = 0

var ad_view : AdView # only for banner?
#interstitial ads...
var interstitial_ad : InterstitialAd
var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
#rewarded ad, what was this one again?
var rewarded_ad : RewardedAd
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
#rewarded interstitial ad
var rewarded_interstitial_ad : RewardedInterstitialAd
var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
# reward listener?
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()


func _ready():
	show_notification("ready notification, test")
	color_rect.size = screen_size
	player.position = screen_size/2
	play_area_collider.shape.size = screen_size * 1.1
	for emitter in $Background.get_children():
		emitter.position.x = screen_size.x
		emitter.position.y = screen_size.y / 2
		emitter.process_material.emission_box_extents.y = screen_size.y / 2
	
	### ADDMOB initialize
	MobileAds.initialize()
	
	### interstitial init
	interstitial_ad_load_callback.on_ad_loaded = on_interstitial_ad_loaded
	interstitial_ad_load_callback.on_ad_failed_to_load = on_ad_load_failed

	### rewarded init
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	rewarded_ad_load_callback.on_ad_failed_to_load = on_ad_load_failed
	
	### rewarded interstitial init
	rewarded_interstitial_ad_load_callback.on_ad_loaded = on_rewarded_interstitial_ad_loaded
	rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = on_ad_load_failed
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		show_notification("on_user_earned_reward, rewarded_item: rewarded\n%d\n%s" % [rewarded_item.amount, rewarded_item.type])
		rewarded_pre_game_complete()
	### load the ads?
	fullscreen_advert()
	fullscreen_rewarded_advert()
	
	if AdManager.banner_in_menu:
		banner_advert()
		#ad_view.show()


func _on_player_dead():
	end_game_sound.play()
	if AdManager.fullscreen_after_game:
		if interstitial_ad:
			interstitial_ad.show()
		else:
			show_notification("no interstitial")
	if AdManager.banner_in_menu:
		banner_advert()
	else:
		hide_banner_advert()
	
	player.animation_player.play("RESET")
	player.visible = false
	ui.visible = false
	for asteroid in $AsteroidLayer.get_children():
		asteroid.queue_free()
	highscores.check_score(score)
	player.change_score(score)
	highscores.visible = true


func _on_play_button_pressed():
	start_game_sound.play()
	if AdManager.rewarded_on_start:
		if rewarded_interstitial_ad:
			rewarded_interstitial_ad.show(on_user_earned_reward_listener)
			_on_ui_pause()
		else:
			show_notification("no rewarded interstitial")
	if AdManager.banner_in_game:
		banner_advert()
	else:
		hide_banner_advert()
		
	score = 0
	ui.set_score_text(score)
	player.visible = true
	player.velocity = Vector2.ZERO
	player.position = screen_size/2
	player.rotation = 0.0
	ui.visible = true
	player.health = player.start_health
	player.shield = player.start_shield
	player.shield_max = player.start_shield
	ui.set_hull_health(player.health)
	ui.set_shield_health(player.shield)
	menu.visible = false


func _on_about_button_pressed():
	menu.visible = false 
	about.visible = true


func _on_quit_button_pressed():
	get_tree().quit()


func _on_back_button_pressed():
	menu.visible = true 
	about.visible = false


func _on_highscores_back_button_pressed():
	menu.visible = true
	highscores.visible = false


func _on_menu_highscores_button_pressed():
	menu.visible = false
	highscores.visible = true


func _on_menu_settings_button_pressed():
	menu.visible = false
	settings.visible = true


func _on_about_settings_pressed() -> void:
	about.visible = false
	settings.visible = true


func _on_settings_settings_back_button_pressed():
	settings.visible = false
	menu.visible = true


func _on_menu_upgrades_button_pressed() -> void:
	menu.visible = false
	permanent_upgrade_screen.visible = true


func _on_permanent_upgrade_screen_exit_pressed() -> void:
	permanent_upgrade_screen.visible = false
	menu.visible = true
	

func _on_play_area_body_exited(body):
	if body is Asteroid:
		print_debug("asteroiod exit play area")
		body.queue_free()
		return
	if body is Bullet:
		print_debug("bullet exit play area")
		body.queue_free()
		return


func _on_player_hull_damage():
	ui.set_hull_health(player.health)


func _on_player_shield_damage():
	ui.set_shield_health(player.shield)


func _on_player_shield_regained():
	ui.set_shield_health(player.shield)


func _on_ui_pause():
	ui.visible = false
	pause_screen.visible = true
	Engine.time_scale = 0


func _on_pause_screen_resume():
	ui.visible = true
	pause_screen.visible = false
	Engine.time_scale = 1


func _on_upgrade_screen_hull():
	player.health += 1
	ui.set_hull_health(player.health)
	resume_from_upgrade()


func _on_upgrade_screen_rate_of_fire():
	player.rate_of_fire *= 0.9
	print(player.rate_of_fire)
	resume_from_upgrade()


func _on_upgrade_screen_shield():
	player.shield += 1
	player.shield_max += 1
	ui.set_shield_health(player.shield)
	resume_from_upgrade()


func _on_upgrade_screen_shield_delay():
	player.shield_recharge_delay *= 0.9
	resume_from_upgrade()


func _on_upgrade_screen_shield_recharge():
	player.shield_recharge_time *= 0.9
	resume_from_upgrade()


func inc_score():
	score += 1
	ui.set_score_text(score)


func upgrade_collected():
	ui.visible = false
	upgrade_screen.init(player.shield_max > 0)
	upgrade_screen.visible = true
	Engine.time_scale = 0


func resume_from_upgrade():
	ui.visible = true
	upgrade_screen.visible = false
	Engine.time_scale = 1


func banner_advert():
	#if ad_view:
		#ad_view.destroy()
		#ad_view = null
	ad_view = AdView.new(
		AdManager.BANNER_ID,
		AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH),
		AdPosition.Values.TOP
	)
	ad_view.load_ad(AdRequest.new())


func hide_banner_advert():
	if ad_view:
		ad_view.hide()


func fullscreen_advert():
	#if interstitial_ad:
		#interstitial_ad.destroy()
		#interstitial_ad = null
	InterstitialAdLoader.new().load(AdManager.FULLSCREEN_AFTER_GAME_ID, AdRequest.new(), interstitial_ad_load_callback)


func fullscreen_rewarded_advert():
	#if rewarded_interstitial_ad:
		#rewarded_interstitial_ad.destroy()
		#rewarded_interstitial_ad = null
	RewardedInterstitialAdLoader.new().load(AdManager.REWARDED_ON_START_ID, AdRequest.new(), rewarded_interstitial_ad_load_callback)


### ADDMOB ADVERT FUNCS
# generic ad failed
func on_ad_load_failed(adError : LoadAdError):
	show_notification(adError.message)


# interstitial
func on_interstitial_ad_loaded(ad : InterstitialAd):
	self.interstitial_ad = ad


# rewarded
func on_rewarded_ad_loaded(ad : RewardedAd):
	self.rewarded_ad = ad


# rewarded interstitial
func on_rewarded_interstitial_ad_loaded(ad : RewardedInterstitialAd):
	self.rewarded_interstitial_ad = ad


func rewarded_pre_game_complete():
	player.health += 1
	ui.set_hull_health(player.health)


func show_notification(string : String):
	#var notifi = notification_yoke.instantiate()
	#add_child(notifi)
	#notifi.init(string)
	pass

	
