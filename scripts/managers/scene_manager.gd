extends Node

@export var main_menu_scene : PackedScene
@export var game_scene : PackedScene
@export var about_scene : PackedScene
@export var highscores_scene : PackedScene
@export var settings_scene : PackedScene
@export var shop_scene : PackedScene

#var _current_scene : PackedScene


# I dont think i actually want this, i mean... they are their own sceenes managed with visibility
# do i just link the button signals here to pull it out of the giant main scene?

# yes, this seems like a plan

# no
# this involves linking like 100 signals into this fucking class...
# fuck that noise

# signal linking is something i really gotta do different... 
# this manual shit is braindead...

# i could put a callable in the emission... 
# and then just one "_on_signal(callable, args[]): callable(args[])" ?

# i feel like this is going to put some serrious time requirement to everysignal though...

# how i test performance eh?

# do a timestamp on click
# timestamp on signal

# timestamp on click
# timestamp on execute
