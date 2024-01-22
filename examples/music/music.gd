extends Node2D


# To understand this example completely, take a look at the MusicBank child node
# on this scene. The music bank contains a single track (MusicResource) which
# contains two stems (MusicStemResource), each of which has an audio stream.


func _ready() -> void:
	# As the MusicManager requires some time to set things up behind the scenes,
	# it's advised that you connect via its "loaded" event before playing any
	# music or enabling or disabling any music track's registered stems.
	MusicManager.loaded.connect(on_music_manager_loaded)


func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("one"):
		# Enabling a stem is technically unmuting it. Therefore, don't expect
		# the stem to begin playback at the start of its stream. Stems will
		# unmute immediately and should be already synced with the track.
		MusicManager.enable_stem("boss", "drums")
		
	if p_event.is_action_pressed("one"):
		# Disabling a stem is technically muting it. It will continuing playing
		# in the background, however, inaudible. This ensures the stem stays
		# in-sync with all other stems associated with the music track.
		MusicManager.disable_stem("boss", "drums")


func on_music_manager_loaded() -> void:
	# Calling play on the MusicManager with the name of a track will immediately
	# begin playing all associated stems that have been marked as "enabled".
	# All music is automatically played through the bus configured in the
	# project settings (Audio/Manager/Music/Bank), otherwise "Master".
	MusicManager.play("boss")
