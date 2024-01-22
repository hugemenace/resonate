extends Node


signal loaded

var _music_table: Dictionary = {}
var _music_streams: Dictionary = {}
var _loaded: bool = false


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
			add_music(event.name, event.stems)


func add_music(p_name: String, p_stems: Array[MusicStemResource]) -> void:
	_music_table[p_name] = p_stems.map(func (stem: MusicStemResource): return {
		"name": stem.name,
		"enabled": stem.enabled,
		"stream": stem.stream,
	})
	

func play(p_name: String) -> AudioStreamPlayer:
	if not _music_table.has(p_name):
		push_error("AudioManager - Tried to play an unknown music track: [%s]." % p_name)
		return
	
	var player = AudioStreamPlayer.new()
	var stream = AudioStreamPolyphonic.new()
	var stems = _music_table[p_name] as Array[Dictionary]
	
	if stems.size() == 0:
		push_error("AudioManager - The music track [%s] has no stems, you'll need to add one at minimum." % p_name)
		return
		
	for stem in stems:
		if stem.stream == null:
			push_error("AudioManager - The stem [%s] on the music track [%s] does not have an audio stream, you'll need to add one." % [stem.name, p_name])
			return
	
	add_child(player)
	
	stream.polyphony = stems.size()
	player.max_polyphony = stems.size()
	player.stream = stream
	player.play()
	
	var playback = player.get_stream_playback() as AudioStreamPlaybackPolyphonic
	
	var music_stream = {
		"player": player,
		"stems": {},
	}
	
	for stem in stems:
		var stream_id = playback.play_stream(stem.stream)
		
		playback.set_stream_volume(stream_id, 0.0 if stem.enabled else -128.0)
		
		music_stream["stems"][stem.name] = {
			"name": stem.name,
			"enabled": stem.enabled,
			"stream_id": stream_id,
		}
	
	_music_streams[p_name] = music_stream
	
	return player


func set_stem(p_name: String, p_stem_name: String, p_enabled: bool = true) -> void:
	if not _music_streams.has(p_name):
		push_error("AudioManager - Cannot toggle the stem [%s] as the music track [%s] is not currently playing." % [p_stem_name, p_name])
		return
	
	var playback = _music_streams[p_name]["player"].get_stream_playback() as AudioStreamPlaybackPolyphonic
	
	for stem in _music_streams[p_name]["stems"].values():
		var enabled = _music_streams[p_name]["stems"][stem.name]["enabled"]
		
		if stem.name == p_stem_name:
			enabled = p_enabled
			_music_streams[p_name]["stems"][stem.name]["enabled"] = enabled
			
		var stream_id = _music_streams[p_name]["stems"][stem.name]["stream_id"]
		
		playback.set_stream_volume(stream_id, 0.0 if enabled else -100.0)


func enable_stem(p_name: String, p_stem_name: String) -> void:
	set_stem(p_name, p_stem_name, true)
	

func disable_stem(p_name: String, p_stem_name: String) -> void:
	set_stem(p_name, p_stem_name, false)
