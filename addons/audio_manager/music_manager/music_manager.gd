extends Node


signal loaded

var _music_table: Dictionary = {}
var _music_streams: Array[StemmedMusicStreamPlayer] = []
var _loaded: bool = false


func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	auto_add_music()


func _process(_p_delta) -> void:
	if _loaded:
		return
		
	_loaded = true
	loaded.emit()


func auto_add_music() -> void:
	var root_nodes = get_tree().root.get_children()
	var music_banks: Array[MusicBank] = []
	
	for node in root_nodes:
		music_banks.append_array(node.find_children("*", "MusicBank"))
	
	for music_bank in music_banks:
		for event in music_bank.tracks:
			add_music(event.name, event.stems, music_bank.mode)


func add_music(p_name: String, p_stems: Array[MusicStemResource], p_mode: Node.ProcessMode) -> void:
	var stems = p_stems.map(func (stem: MusicStemResource): return {
		"name": stem.name,
		"enabled": stem.enabled,
		"stream": stem.stream,
	})
	
	_music_table[p_name] = {
		"mode": p_mode,
		"stems": stems,
	}


func play(p_name: String, p_crossfade_time: float = 3.0) -> StemmedMusicStreamPlayer:
	if not _loaded:
		push_warning("AudioManager - The music track [%s] can't be played as the MusicManager has not loaded yet. Use the [loaded] signal/event to determine when it is ready to play music." % p_name)
		return null
		
	if not _music_table.has(p_name):
		push_error("AudioManager - Tried to play an unknown music track: [%s]." % p_name)
		return
	
	var track = _music_table[p_name] as Dictionary
	var stems = track["stems"] as Array
	
	if stems.size() == 0:
		push_error("AudioManager - The music track [%s] has no stems, you'll need to add one at minimum." % p_name)
		return
		
	for stem in stems:
		if stem.stream == null:
			push_error("AudioManager - The stem [%s] on the music track [%s] does not have an audio stream, you'll need to add one." % [stem.name, p_name])
			return
	
	var player = StemmedMusicStreamPlayer.create(p_name, track.mode)
	
	if _music_streams.size() > 0:
		for stream in _music_streams:
			stream.stop_stems(p_crossfade_time)
	
	_music_streams.append(player)
	
	add_child(player)
	
	player.start_stems(stems, p_crossfade_time)
	player.stopped.connect(on_player_stopped.bind(player))
	
	return player


func stop(p_fade_time: float = 3.0) -> void:
	if _music_streams.size() == 0:
		push_warning("AudioManager - Cannot stop the music track as there is no music currently playing.")
		return
		
	var current_player = _music_streams.back() as StemmedMusicStreamPlayer
	
	current_player.stop_stems(p_fade_time)


func set_stem(p_name: String, p_enabled: bool, p_fade_time: float) -> void:
	if _music_streams.size() == 0:
		push_warning("AudioManager - Cannot toggle the stem [%s] as there is no music currently playing." % p_name)
		return
		
	var current_player = _music_streams.back() as StemmedMusicStreamPlayer
	
	current_player.toggle_stem(p_name, p_enabled, p_fade_time)


func enable_stem(p_name: String, p_fade_time: float = 3.0) -> void:
	set_stem(p_name, true, p_fade_time)


func disable_stem(p_name: String, p_fade_time: float = 3.0) -> void:
	set_stem(p_name, false, p_fade_time)


func is_playing() -> bool:
	return _music_streams.size() > 0


func get_stem_details(p_name: String) -> Variant:
	if _music_streams.size() == 0:
		push_warning("AudioManager - Cannot get the details for stem [%s] as there is no music currently playing." % p_name)
		return
		
	var current_player = _music_streams.back() as StemmedMusicStreamPlayer
	
	return current_player.get_stem_details(p_name)


func on_player_stopped(p_player: StemmedMusicStreamPlayer) -> void:
	if _music_streams.size() == 0:
		return
		
	_music_streams.erase(p_player)
	remove_child(p_player)
