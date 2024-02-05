extends Node2D


# For reference, it's worth taking a moment to inspect the MusicBank attached to 
# this example scene. MusicBanks hold the configuration for all of your music 
# tracks and the stems (MusicStemResources) associated with the music track.


@onready var timer: Timer = $Timer

var _is_playing: bool


func _ready():
	# As the MusicManager requires some preparation when the game loads, we need 
	# to hook into one or more of its lifecycle events before trying to play a
	# music track and/or stems. In this example, we've use the `updated` event 
	# as it's fired whenever any part of the MusicManager's state updates.
	MusicManager.updated.connect(on_music_manager_updated)


func on_music_manager_updated() -> void:
	# The method call below is an inbuilt guard-clause that'll help us avoid playing 
	# a music track and/or stems when the MusicManager has not loaded, or when we've 
	# already set the `_is_playing` variable to true (returned by the play method).
	if MusicManager.should_skip_playing(_is_playing):
		return
	
	_is_playing = MusicManager.play("scene_one", "track_a")
	
	# If you know that a scene will be inserted or removed at runtime, and you
	# don't want to hook into lifecycle events to ensure your music tracks
	# stop playing, you can instruct the MusicManager to do it for you.
	MusicManager.auto_stop(self, "scene_one", "track_a")
