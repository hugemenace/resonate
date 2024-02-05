extends Node2D


# For reference, it's worth taking a moment to inspect the MusicBank attached to 
# this example scene. MusicBanks hold the configuration for all of your music 
# tracks and the stems (MusicStemResources) associated with the music track.


@onready var stem_details = $StemDetails

const _TRACKS: Array[String] = ["house", "breakbeat"]

var _is_playing: bool
var _track_number: int = 0
var _track_name: String = _TRACKS[_track_number]


func _ready() -> void:
	# As the MusicManager requires some preparation when the game loads, we need 
	# to hook into one or more of its lifecycle events before trying to play a
	# music track and/or stems. In this example, we've use the `updated` event 
	# as it's fired whenever any part of the MusicManager's state updates.
	MusicManager.updated.connect(on_music_manager_updated)


func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("one"):
		MusicManager.enable_stem("melody")
		
	if p_event.is_action_released("one"):
		MusicManager.disable_stem("melody")
		
	if p_event.is_action_pressed("two"):
		MusicManager.enable_stem("drums")
		
	if p_event.is_action_released("two"):
		MusicManager.disable_stem("drums")
		
	if p_event.is_action_pressed("three"):
		_track_number = _track_number + 1 if (_track_number + 1) < _TRACKS.size() else 0
		_track_name = _TRACKS[_track_number]
		
		MusicManager.play("instrumental", _track_name)
				
	if p_event.is_action_pressed("four"):
		MusicManager.stop()


func _process(_p_delta):
	if not MusicManager.is_playing():
		stem_details.text = "No music playing."
		return
		
	var melody_stem = MusicManager.get_stem_details("melody")
	var drums_stem = MusicManager.get_stem_details("drums")
	
	if melody_stem == null or drums_stem == null:
		stem_details.text = "Stem details unavailable."
		return
	
	stem_details.text = """Current track: %s
	Melody stem:
	 - Volume: %ddB
	 - Enabled: %s
	Drums stem:
	 - Volume: %ddB
	 - Enabled: %s
	""" % [_track_name, melody_stem.volume, melody_stem.enabled, drums_stem.volume, drums_stem.enabled]


func on_music_manager_updated() -> void:
	# The method call below is an inbuilt guard-clause that'll help us avoid playing 
	# a music track and/or stems when the MusicManager has not loaded, or when we've 
	# already set the `_is_playing` variable to true (returned by the play method).
	if MusicManager.should_skip_playing(_is_playing):
		return
		
	_is_playing = MusicManager.play("instrumental", _track_name)
