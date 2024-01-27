extends Node


signal loaded
signal pool_updated(p_type: PoolType, p_size: int)

enum PoolType {ONE_D, TWO_D, THREE_D}

var _1d_players: Array[PooledAudioStreamPlayer] = []
var _2d_players: Array[PooledAudioStreamPlayer2D] = []
var _3d_players: Array[PooledAudioStreamPlayer3D] = []
var _event_table: Dictionary = {}
var _loaded: bool = false


func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	initialise_pool(ProjectSettings.get_setting(
			ResonatePlugin.POOL_1D_SIZE_SETTING_NAME,
			ResonatePlugin.POOL_1D_SIZE_SETTING_DEFAULT),
			create_player_1d)
			
	initialise_pool(ProjectSettings.get_setting(
			ResonatePlugin.POOL_2D_SIZE_SETTING_NAME,
			ResonatePlugin.POOL_2D_SIZE_SETTING_DEFAULT),
			create_player_2d)
			
	initialise_pool(ProjectSettings.get_setting(
			ResonatePlugin.POOL_3D_SIZE_SETTING_NAME,
			ResonatePlugin.POOL_3D_SIZE_SETTING_DEFAULT),
			create_player_3d)
	
	auto_add_events()
	

func _process(_p_delta) -> void:
	if _loaded:
		return
		
	_loaded = true
	loaded.emit()


func initialise_pool(p_size: int, p_creator_fn: Callable) -> void:
	for i in p_size:
		p_creator_fn.call_deferred()


func auto_add_events() -> void:
	var root_nodes = get_tree().root.get_children()
	var sound_banks: Array[SoundBank] = []
	
	for node in root_nodes:
		sound_banks.append_array(node.find_children("*", "SoundBank"))
	
	for sound_bank in sound_banks:
		add_bank(sound_bank.label, sound_bank.mode)
		for event in sound_bank.events:
			var bus = get_bus(sound_bank.bus, event.bus)
			add_event(sound_bank.label, event.name, bus, event.streams)
			

func add_bank(p_bank_label: String, p_mode: Node.ProcessMode) -> void:
	_event_table[p_bank_label] = {
		"mode": p_mode,
		"events": {}
	}


func add_event(p_bank_label: String, p_event_name: String, p_bus: String, p_streams: Array[AudioStream]) -> void:
	_event_table[p_bank_label]["events"][p_event_name] = {
		"bus": p_bus,
		"streams": p_streams,
	}


func get_mode(p_bank_label: String) -> Node.ProcessMode:
	if not _event_table.has(p_bank_label):
		push_error("Resonate - Tried to get the process mode from an unknown bank [%s]" % p_bank_label)
		return PROCESS_MODE_INHERIT
		
	return _event_table[p_bank_label]["mode"] as Node.ProcessMode


func get_event(p_bank_label: String, p_event_name: String) -> Dictionary:
	var empty_event = {
		"bus": "",
		"streams": [],
	}
		
	if not _event_table.has(p_bank_label):
		push_error("Resonate - Tried to get the event [%s] from an unknown bank [%s]" % [p_event_name, p_bank_label])
		return empty_event
		
	if not _event_table[p_bank_label]["events"].has(p_event_name):
		push_error("Resonate - Tried to get an unknown event [%s] from the bank [%s]" % [p_event_name, p_bank_label])
		return empty_event
		
	var event = _event_table[p_bank_label]["events"][p_event_name]
	
	if event.streams.size() == 0:
		push_error("Resonate - The event [%s] on bank [%s] has no playable streams, you'll need to add at least one." % [p_event_name, p_bank_label])
		return empty_event
	
	return event


func get_bus(p_bank_bus: String, p_event_bus: String) -> String:
	if p_event_bus != null and p_event_bus != "":
		return p_event_bus
	
	if p_bank_bus != null and p_bank_bus != "":
		return p_bank_bus
		
	return ProjectSettings.get_setting(
		ResonatePlugin.SOUND_BANK_SETTING_NAME,
		ResonatePlugin.SOUND_BANK_SETTING_DEFAULT)


func instance_manual(p_bank_label: String, p_event_name: String, p_trigger: bool = true, p_bus: String = "", p_poly: bool = false, p_attachment = null) -> Variant:
	if not _loaded:
		push_warning("Resonate - The event [%s] on bank [%s] can't be played as the SoundManager has not loaded yet. Use the [loaded] signal/event to determine when it is ready to play sounds." % [p_event_name, p_bank_label])
		return null
		
	var event = get_event(p_bank_label, p_event_name)
	var player = get_player(p_attachment)
	
	if event.streams.size() == 0 or player == null:
		push_error("Resonate - The event [%s] on bank [%s] can't be played; no streams or players available." % [p_event_name, p_bank_label])
		return null
	
	if is_vector_attachment(p_attachment):
		player.global_position = p_attachment
		
	if is_node_attachment(p_attachment):
		player.global_position = p_attachment.global_position
		player.reparent(p_attachment)
		
	var bus = p_bus if p_bus != "" else event.bus
	var mode = get_mode(p_bank_label)
	
	player.configure(event.streams, bus, p_poly, mode)
	
	if p_trigger:
		player.trigger(p_trigger)
		
	pool_updated.emit(player.pool_type, get_pool_size(player.pool_type))
	
	return player


func play(p_bank_label: String, p_event_name: String, p_bus: String = "") -> void:
	instance_manual(p_bank_label, p_event_name, true, p_bus, false, null)
	

func play_at_position(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> void:
	instance_manual(p_bank_label, p_event_name, true, p_bus, false, p_position)
	

func play_on_node(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> void:
	instance_manual(p_bank_label, p_event_name, true, p_bus, false, p_node)


func instance(p_bank_label: String, p_event_name: String, p_bus: String = "") -> Variant:
	return instance_manual(p_bank_label, p_event_name, false, p_bus, false, null)
	

func instance_at_position(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> Variant:
	return instance_manual(p_bank_label, p_event_name, false, p_bus, false, p_position)
	

func instance_on_node(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> Variant:
	return instance_manual(p_bank_label, p_event_name, false, p_bus, false, p_node)
	
	
func instance_poly(p_bank_label: String, p_event_name: String, p_bus: String = "") -> Variant:
	return instance_manual(p_bank_label, p_event_name, false, p_bus, true, null)
	

func instance_at_position_poly(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> Variant:
	return instance_manual(p_bank_label, p_event_name, false, p_bus, true, p_position)
	

func instance_on_node_poly(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> Variant:
	return instance_manual(p_bank_label, p_event_name, false, p_bus, true, p_node)


func is_player_free(p_player) -> bool:
	return not p_player.playing and not p_player.reserved


func get_player_from_pool(p_pool: Array) -> Variant:
	if p_pool.size() == 0:
		push_error("Resonate - Player pool has not been initialised. This can occur when calling a [play/instance*] function from [_ready].")
		return null
	
	for player in p_pool:
		if is_player_free(player):
			return player
	
	push_warning("Resonate - Player pool exhausted, consider increasing the pool size in the project settings (Audio/Manager/Pooling) or releasing unused audio stream players.")
	return null
	

func get_player_1d() -> PooledAudioStreamPlayer:
	return get_player_from_pool(_1d_players)
	

func get_player_2d() -> PooledAudioStreamPlayer2D:
	return get_player_from_pool(_2d_players)
	

func get_player_3d() -> PooledAudioStreamPlayer3D:
	return get_player_from_pool(_3d_players)


func get_player(p_attachment = null) -> Variant:
	if p_attachment is Vector2 or p_attachment is Node2D:
		return get_player_2d()
	
	if p_attachment is Vector3 or p_attachment is Node3D:
		return get_player_3d()
		
	return get_player_1d()


func is_vector_attachment(p_attachment = null) -> bool:
	return true if p_attachment is Vector2 or p_attachment is Vector3 else false
	

func is_node_attachment(p_attachment = null) -> bool:
	return true if p_attachment is Node2D or p_attachment is Node3D else false


func add_player_to_pool(p_player, p_pool) -> Variant:
	add_child(p_player)
	
	p_player.released.connect(on_player_released.bind(p_player))
	p_pool.append(p_player)
	
	return p_player


func get_pool_size(p_type: PoolType) -> int:
	if p_type == PoolType.ONE_D:
		return _1d_players.filter(is_player_free).size()
	
	if p_type == PoolType.TWO_D:
		return _2d_players.filter(is_player_free).size()
		
	if p_type == PoolType.THREE_D:
		return _3d_players.filter(is_player_free).size()
		
	return 0


func create_player_1d() -> PooledAudioStreamPlayer:
	return add_player_to_pool(PooledAudioStreamPlayer.create(PoolType.ONE_D), _1d_players)
	

func create_player_2d() -> PooledAudioStreamPlayer2D:
	return add_player_to_pool(PooledAudioStreamPlayer2D.create(PoolType.TWO_D), _2d_players)
	
	
func create_player_3d() -> PooledAudioStreamPlayer3D:
	return add_player_to_pool(PooledAudioStreamPlayer3D.create(PoolType.THREE_D), _3d_players)
	

func on_player_released(p_player: Node) -> void:
	var player_parent = p_player.get_parent()
	
	if player_parent == null or not player_parent == self:
		p_player.reparent(self)
	
	pool_updated.emit(p_player.pool_type, get_pool_size(p_player.pool_type))
