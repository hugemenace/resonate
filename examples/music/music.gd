extends Node2D


# To understand this example completely, take a look at the MusicBank child node
# on this scene. The music bank contains a single track (MusicResource) which
# contains two stems (MusicStemResource), each of which has an audio stream.

@onready var stem_details = $StemDetails

const _TRACKS: Array[String] = ["track_a", "track_b"]

var _track_number: int = 1


func _ready() -> void:
	# As the MusicManager requires some time to set things up behind the scenes,
	# it's advised that you connect via its "loaded" event before playing any
	# music or enabling or disabling any music track's registered stems.
	MusicManager.loaded.connect(on_music_manager_loaded)


func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("one"):
		# Enabling a stem is technically unmuting it. Therefore, don't expect
		# the stem to begin playback at the start of its stream. Stems will
		# unmute immediately and fade in over the duration (or default) set.
		MusicManager.enable_stem("melody")
		
	if p_event.is_action_released("one"):
		# Disabling a stem is technically muting it. It will continuing playing
		# in the background, however, inaudible. This ensures the stem stays
		# in-sync with all other stems associated with the music track.
		MusicManager.disable_stem("melody")
		
	if p_event.is_action_pressed("two"):
		MusicManager.enable_stem("drums")
		
	if p_event.is_action_released("two"):
		MusicManager.disable_stem("drums")
		
	if p_event.is_action_pressed("three"):
		MusicManager.play("instrumental", _TRACKS[_track_number])
		# Loop back around to the start if we've hit the end of the track list.
		_track_number = _track_number + 1 if (_track_number + 1) < _TRACKS.size() else 0
				
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
	
	stem_details.text = """Melody stem:
	 - Volume: %ddB
	 - Enabled: %s
	Drums stem:
	 - Volume: %ddB
	 - Enabled: %s
	""" % [melody_stem.volume, melody_stem.enabled, drums_stem.volume, drums_stem.enabled]


func on_music_manager_loaded() -> void:
	# Calling play on the music manager with the name of a music bank and a track
	# will immediately begin playing the track. All stems on the track marked as
	# enabled will be audible. Playback will fade in over the default duration.
	MusicManager.play("instrumental", _TRACKS[0])
