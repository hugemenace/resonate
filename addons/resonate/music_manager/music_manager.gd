extends Node


signal loaded
signal banks_updated
signal updated

var has_loaded: bool = false

var _music_table: Dictionary = {}
var _music_table_hash: int
var _music_streams: Array[StemmedMusicStreamPlayer] = []
var _volume: float


func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	auto_add_music()
	
	var scene_root = get_tree().root.get_tree()
	scene_root.node_added.connect(on_scene_node_added)
	scene_root.node_removed.connect(on_scene_node_removed)


func _process(_p_delta) -> void:
	if _music_table_hash != _music_table.hash():
		_music_table_hash = _music_table.hash()
		banks_updated.emit()
		updated.emit()
		
	if has_loaded:
		return
		
	has_loaded = true
	loaded.emit()
	updated.emit()


func on_scene_node_added(p_node: Node) -> void:
	if not p_node is MusicBank:
		return
		
	add_bank(p_node)
	
	
func on_scene_node_removed(p_node: Node) -> void:
	if not p_node is MusicBank:
		return
		
	remove_bank(p_node)


func auto_add_music() -> void:
	var music_banks = ResonateUtils.find_all_nodes(self, "MusicBank")
	
	for music_bank in music_banks:
		add_bank(music_bank)
		
	_music_table_hash = _music_table.hash()


func add_bank(p_bank: MusicBank) -> void:
	_music_table[p_bank.label] = {
		"name": p_bank.label,
		"bus": p_bank.bus,
		"mode": p_bank.mode,
		"tracks": create_tracks(p_bank.tracks)
	}


func remove_bank(p_bank: MusicBank) -> void:
	_music_table.erase(p_bank.label)


func create_tracks(p_tracks: Array[MusicTrackResource]) -> Dictionary:
	var tracks = {}
	
	for track in p_tracks:
		tracks[track.name] = {
			"name": track.name,
			"bus": track.bus,
			"stems": create_stems(track.stems),
		}

	return tracks


func create_stems(p_stems: Array[MusicStemResource]) -> Array:
	var stems = []
	
	for stem in p_stems:
		stems.append({
			"name": stem.name,
			"enabled": stem.enabled,
			"volume": stem.volume,
			"stream": stem.stream,
		})
		
	return stems


func get_bus(p_bank_bus: String, p_track_bus: String) -> String:
	if p_track_bus != null and p_track_bus != "":
		return p_track_bus
	
	if p_bank_bus != null and p_bank_bus != "":
		return p_bank_bus
		
	return ProjectSettings.get_setting(
		ResonatePlugin.MUSIC_BANK_SETTING_NAME,
		ResonatePlugin.MUSIC_BANK_SETTING_DEFAULT)


func is_playing_music() -> bool:
	return _music_streams.size() > 0


func get_current_player() -> StemmedMusicStreamPlayer:
	if _music_streams.size() == 0:
		return null
		
	return _music_streams.back() as StemmedMusicStreamPlayer


func play(p_bank_label: String, p_track_name: String, p_crossfade_time: float = 5.0) -> bool:
	if not has_loaded:
		push_error("Resonate - The music track [%s] on bank [%s] can't be played as the MusicManager has not loaded yet. Use the [loaded] signal/event to determine when it is ready." % [p_track_name, p_bank_label])
		return false
		
	if not _music_table.has(p_bank_label):
		push_error("Resonate - Tried to play the music track [%s] from an unknown bank [%s]." % [p_track_name, p_bank_label])
		return false
		
	if not _music_table[p_bank_label]["tracks"].has(p_track_name):
		push_error("Resonate - Tried to play an unknown music track [%s] from the bank [%s]." % [p_track_name, p_bank_label])
		return false
	
	var bank = _music_table[p_bank_label] as Dictionary
	var track = bank["tracks"][p_track_name] as Dictionary
	var stems = track["stems"] as Array
	
	if stems.size() == 0:
		push_error("Resonate - The music track [%s] on bank [%s] has no stems, you'll need to add one at minimum." % [p_track_name, p_bank_label])
		return false
		
	for stem in stems:
		if stem.stream == null:
			push_error("Resonate - The stem [%s] on the music track [%s] on bank [%s] does not have an audio stream, you'll need to add one." % [stem.name, p_track_name, p_bank_label])
			return false
			
		if not ResonateUtils.is_stream_looped(stem.stream):
			push_warning("Resonate - The stem [%s] on the music track [%s] on bank [%s] is not set to loop, which will cause it to work incorrectly." % [stem.name, p_track_name, p_bank_label])
	
	var bus = get_bus(bank.bus, track.bus)
	var player = StemmedMusicStreamPlayer.create(p_bank_label, p_track_name, bus, bank.mode, _volume)
	
	if _music_streams.size() > 0:
		for stream in _music_streams:
			stream.stop_stems(p_crossfade_time)
	
	_music_streams.append(player)
	
	add_child(player)
	
	player.start_stems(stems, p_crossfade_time)
	player.stopped.connect(on_player_stopped.bind(player))
	
	return true


func is_playing(p_bank_label: String = "", p_track_name: String = "") -> bool:
	if not has_loaded:
		return false
	
	if _music_streams.size() == 0:
		return false
		
	var current_player = get_current_player()
	var is_playing = not current_player.is_stopping
	var bank_label = current_player.bank_label
	var track_name = current_player.track_name
	
	if p_bank_label == "" and p_track_name == "":
		return is_playing
		
	if p_bank_label != "" and p_track_name == "":
		return bank_label == p_bank_label and is_playing
		
	if p_bank_label == "" and p_track_name != "":
		return track_name == p_track_name and is_playing
		
	return bank_label == p_bank_label and track_name == p_track_name and is_playing


func stop(p_fade_time: float = 5.0) -> void:
	if not is_playing_music():
		push_warning("Resonate - Cannot stop the music track as there is no music currently playing.")
		return
		
	var current_player = get_current_player()
	
	current_player.stop_stems(p_fade_time)


func should_skip_playing(p_flag) -> bool:
	return not has_loaded or (p_flag != false and p_flag != null)


func set_volume(p_volume: float) -> void:
	_volume = p_volume
	
	if not is_playing_music():
		return
		
	var current_player = get_current_player()
	
	current_player.set_volume(_volume)


func set_stem(p_name: String, p_enabled: bool, p_fade_time: float) -> void:
	if not is_playing_music():
		push_warning("Resonate - Cannot toggle the stem [%s] as there is no music currently playing." % p_name)
		return
		
	var current_player = get_current_player()
	
	current_player.toggle_stem(p_name, p_enabled, p_fade_time)


func enable_stem(p_name: String, p_fade_time: float = 2.0) -> void:
	set_stem(p_name, true, p_fade_time)


func disable_stem(p_name: String, p_fade_time: float = 2.0) -> void:
	set_stem(p_name, false, p_fade_time)


func set_stem_volume(p_name: String, p_volume: float) -> void:
	if not is_playing_music():
		push_warning("Resonate - Cannot set the volume of stem [%s] as there is no music currently playing." % p_name)
		return
		
	var current_player = get_current_player()
	
	current_player.set_stem_volume(p_name, p_volume)


func get_stem_details(p_name: String) -> Variant:
	if not is_playing_music():
		push_warning("Resonate - Cannot get the details for stem [%s] as there is no music currently playing." % p_name)
		return
		
	var current_player = get_current_player()
	
	return current_player.get_stem_details(p_name)


func auto_stop(p_base: Node, p_bank_label: String, p_track_name: String, p_fade_time: float = 5.0) -> void:
	p_base.tree_exiting.connect(on_music_player_exiting.bind(p_bank_label, p_track_name, p_fade_time))


func on_music_player_exiting(p_bank_label: String, p_track_name: String, p_fade_time: float) -> void:
	if not is_playing(p_bank_label, p_track_name):
		return
	
	stop(p_fade_time)
	

func on_player_stopped(p_player: StemmedMusicStreamPlayer) -> void:
	if not is_playing_music():
		return
		
	_music_streams.erase(p_player)
	remove_child(p_player)
