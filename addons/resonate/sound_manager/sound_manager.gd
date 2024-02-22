extends Node
## The SoundManager is responsible for all sound events in your game.
##
## It manages pools of 1D, 2D, and 3D audio stream players, which can be used
## for single-shot sound events, or reserved by scripts for repetitive & exclusive use.
## Sound events can contain many variations which will be chosen and played at random.
## Playback can be achieved both sequentially and polyphonically.
##
## @tutorial(View example scenes): https://github.com/hugemenace/resonate/tree/main/examples


const ResonateSettings = preload("../shared/resonate_settings.gd")
var _settings = ResonateSettings.new()

## Emitted only once when the SoundManager has finished setting up and 
## is ready to play or instance sound events.
signal loaded

## Emitted every time the SoundManager detects that a SoundBank has
## been added or removed from the scene tree.
signal banks_updated

## Emitted every time one of the player pools is updated.
signal pools_updated

## Emitted whenever [signal SoundManager.loaded], [signal SoundManager.banks_updated],
## or [signal SoundManager.pools_updated] is emitted.
signal updated

## Whether the SoundManager has completed setup and is ready to play or instance sound events.
var has_loaded: bool = false

var _1d_players: Array[PooledAudioStreamPlayer] = []
var _2d_players: Array[PooledAudioStreamPlayer2D] = []
var _3d_players: Array[PooledAudioStreamPlayer3D] = []
var _event_table: Dictionary = {}
var _event_table_hash: int


# ------------------------------------------------------------------------------
# Lifecycle methods
# ------------------------------------------------------------------------------


func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	_initialise_pool(ProjectSettings.get_setting(
			_settings.POOL_1D_SIZE_SETTING_NAME,
			_settings.POOL_1D_SIZE_SETTING_DEFAULT),
			_create_player_1d)
			
	_initialise_pool(ProjectSettings.get_setting(
			_settings.POOL_2D_SIZE_SETTING_NAME,
			_settings.POOL_2D_SIZE_SETTING_DEFAULT),
			_create_player_2d)
			
	_initialise_pool(ProjectSettings.get_setting(
			_settings.POOL_3D_SIZE_SETTING_NAME,
			_settings.POOL_3D_SIZE_SETTING_DEFAULT),
			_create_player_3d)
	
	_auto_add_events()
	
	var scene_root = get_tree().root.get_tree()
	scene_root.node_added.connect(_on_scene_node_added)
	scene_root.node_removed.connect(_on_scene_node_removed)
	

func _process(_p_delta) -> void:
	if _event_table_hash != _event_table.hash():
		_event_table_hash = _event_table.hash()
		banks_updated.emit()
		updated.emit()
		
	if has_loaded:
		return
		
	has_loaded = true
	loaded.emit()
	updated.emit()


# ------------------------------------------------------------------------------
# Public methods
# ------------------------------------------------------------------------------


## Returns a new Null player (null object pattern) which mimics a [PooledAudioStreamPlayer],
## allowing you to call methods such as [method PooledAudioStreamPlayer.trigger]
## without the need to wrap the call in a null check.
func null_instance() -> NullPooledAudioStreamPlayer:
	return NullPooledAudioStreamPlayer.new()
	

## Returns a new Null player (null object pattern) which mimics a [PooledAudioStreamPlayer2D],
## allowing you to call methods such as [method PooledAudioStreamPlayer2D.trigger]
## without the need to wrap the call in a null check.
func null_instance_2d() -> NullPooledAudioStreamPlayer2D:
	return NullPooledAudioStreamPlayer2D.new()
	

## Returns a new Null player (null object pattern) which mimics a [PooledAudioStreamPlayer3D],
## allowing you to call methods such as [method PooledAudioStreamPlayer3D.trigger]
## without the need to wrap the call in a null check.
func null_instance_3d() -> NullPooledAudioStreamPlayer3D:
	return NullPooledAudioStreamPlayer3D.new()


## Used to determine whether the given [b]p_instance[/b] variable can be instantiated. It will return 
## true if the SoundManager hasn't loaded yet, if the instance is already instantiated, 
## or if the instance has been instantiated but is currently being released.
func should_skip_instancing(p_instance) -> bool:
	if not has_loaded:
		return true
		
	if p_instance != null and p_instance.releasing:
		return true
	
	if p_instance != null and not p_instance.is_null():
		return true
		
	return false


## This a shorthand method used to instantiate a new instance while optionally configuring it 
## to be automatically released when the given [b]p_base[/b] is removed from the scene tree.[br][br]
## The [b]p_factory[/b] callable is used to create the instance required. See example below:[br][br]
## [codeblock]
## _instance_note_one = SoundManager.quick_instance(_instance_note_one,
##			SoundManager.instance.bind("example", "one"), self)
## [/codeblock]
func quick_instance(p_instance, p_factory: Callable, p_base: Node = null, p_finish_playing: bool = false) -> Variant:
	if should_skip_instancing(p_instance):
		return
		
	var new_instance = p_factory.call()
	
	if p_base != null:
		release_on_exit(p_base, new_instance, p_finish_playing)
		
	return new_instance


## Play a sound event from a SoundBank.
func play(p_bank_label: String, p_event_name: String, p_bus: String = "") -> void:
	var instance = _instance_manual(p_bank_label, p_event_name, false, p_bus, false, null)
	instance.trigger()
	instance.release(true)
	
	
## Play a sound event from a SoundBank at a specific [b]Vector2[/b] or [b]Vector3[/b] position.
func play_at_position(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> void:
	var instance = _instance_manual(p_bank_label, p_event_name, false, p_bus, false, p_position)
	instance.trigger()
	instance.release(true)
	

## Play a sound event from a SoundBank on a [b]Node2D[/b] or [b]Node3D[/b]. This causes the sound to
## synchronise with the Node's global position - causing it to move in 2D or 3D space along with the Node.
func play_on_node(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> void:
	var instance = _instance_manual(p_bank_label, p_event_name, false, p_bus, false, p_node)
	instance.trigger()
	instance.release(true)
	

## Play a sound event from a SoundBank with the provided pitch and/or volume.
func play_varied(p_bank_label: String, p_event_name: String, p_pitch: float = 1.0, p_volume: float = 0.0, p_bus: String = "") -> void:
	var instance = _instance_manual(p_bank_label, p_event_name, false, p_bus, false, null)
	instance.trigger_varied(p_pitch, p_volume)
	instance.release(true)
	

## Play a sound event from a SoundBank at a specific [b]Vector2[/b] or [b]Vector3[/b] 
## position with the provided pitch and/or volume.
func play_at_position_varied(p_bank_label: String, p_event_name: String, p_position, p_pitch: float = 1.0, p_volume: float = 0.0, p_bus: String = "") -> void:
	var instance = _instance_manual(p_bank_label, p_event_name, false, p_bus, false, p_position)
	instance.trigger_varied(p_pitch, p_volume)
	instance.release(true)
	

## Play a sound event from a SoundBank on a [b]Node2D[/b] or [b]Node3D[/b] with the provided pitch 
## and/or volume. This causes the sound to synchronise with the Node's global position - causing 
## it to move in 2D or 3D space along with the Node.
func play_on_node_varied(p_bank_label: String, p_event_name: String, p_node, p_pitch: float = 1.0, p_volume: float = 0.0, p_bus: String = "") -> void:
	var instance = _instance_manual(p_bank_label, p_event_name, false, p_bus, false, p_node)
	instance.trigger_varied(p_pitch, p_volume)
	instance.release(true)


## Returns a reserved [PooledAudioStreamPlayer] for you to use exclusively until it is told to 
## [method PooledAudioStreamPlayer.release] or is automatically released when registered
## with [method SoundManager.release_on_exit].
func instance(p_bank_label: String, p_event_name: String, p_bus: String = "") -> Variant:
	return _instance_manual(p_bank_label, p_event_name, true, p_bus, false, null)
	

## Returns a reserved [PooledAudioStreamPlayer2D] or [PooledAudioStreamPlayer3D] (depending on the 
## type of [b]p_position[/b]) placed at a specific 2D or 3D position in the world. You will have 
## exclusive use of it until it is told to [method PooledAudioStreamPlayer.release] or is automatically 
## released when registered with [method SoundManager.release_on_exit].
func instance_at_position(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> Variant:
	return _instance_manual(p_bank_label, p_event_name, true, p_bus, false, p_position)
	

## Returns a reserved [PooledAudioStreamPlayer2D] or [PooledAudioStreamPlayer3D] (depending on the 
## type of [b]p_node[/b]) which will synchronise its global position with [b]p_node[/b]. You will have 
## exclusive use of it until it is told to [method PooledAudioStreamPlayer.release] or is automatically 
## released when registered with [method SoundManager.release_on_exit].
func instance_on_node(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> Variant:
	return _instance_manual(p_bank_label, p_event_name, true, p_bus, false, p_node)
	

## Returns a reserved [PooledAudioStreamPlayer] for you to use exclusively until it is told to 
## [method PooledAudioStreamPlayer.release] or is automatically released when registered
## with [method SoundManager.release_on_exit].[br][br]
## [b]Note:[/b] This method will mark the reserved player as polyphonic (able to play 
## multiple event variations simultaneously.)
func instance_poly(p_bank_label: String, p_event_name: String, p_bus: String = "") -> Variant:
	return _instance_manual(p_bank_label, p_event_name, true, p_bus, true, null)
	

## Returns a reserved [PooledAudioStreamPlayer2D] or [PooledAudioStreamPlayer3D] (depending on the 
## type of [b]p_position[/b]) placed at a specific 2D or 3D position in the world. You will have 
## exclusive use of it until it is told to [method PooledAudioStreamPlayer.release] or is automatically 
## released when registered with [method SoundManager.release_on_exit].[br][br]
## [b]Note:[/b] This method will mark the reserved player as polyphonic (able to play 
## multiple event variations simultaneously.)
func instance_at_position_poly(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> Variant:
	return _instance_manual(p_bank_label, p_event_name, true, p_bus, true, p_position)
	

## Returns a reserved [PooledAudioStreamPlayer2D] or [PooledAudioStreamPlayer3D] (depending on the 
## type of [b]p_node[/b]) which will synchronise its global position with [b]p_node[/b]. You will have 
## exclusive use of it until it is told to [method PooledAudioStreamPlayer.release] or is automatically 
## released when registered with [method SoundManager.release_on_exit].[br][br]
## [b]Note:[/b] This method will mark the reserved player as polyphonic (able to play 
## multiple event variations simultaneously.)
func instance_on_node_poly(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> Variant:
	return _instance_manual(p_bank_label, p_event_name, true, p_bus, true, p_node)


## Will automatically release the given [b]p_instance[/b] when the provided 
## [b]p_base[/b] is removed from the scene tree.
func release_on_exit(p_base: Node, p_instance: Node, p_finish_playing: bool = false) -> void:
	if p_instance == null or p_base == null:
		return
	
	p_base.tree_exiting.connect(p_instance.release.bind(p_finish_playing))


## Will automatically release the given [b]p_instance[/b] when the provided 
## [b]p_base[/b] is removed from the scene tree.[br][br]
## [b]Note:[/b] This method has been deprecated, please use [method SoundManager.release_on_exit] instead.
## @deprecated
func auto_release(p_base: Node, p_instance: Node, p_finish_playing: bool = false) -> Variant:
	push_warning("Resonate - auto_release has been deprecated, please use release_on_exit instead.")
	
	if p_instance == null:
		return p_instance
	
	release_on_exit(p_base, p_instance, p_finish_playing)
	
	return p_instance


## Manually add a new SoundBank into the event cache.
func add_bank(p_bank: SoundBank) -> void:
	_add_bank(p_bank)


## Remove the provided bank from the event cache.
func remove_bank(p_bank_label: String) -> void:
	if not _event_table.has(p_bank_label):
		return
		
	_event_table.erase(p_bank_label)


## Clear all banks from the event cache.
func clear_banks() -> void:
	_event_table.clear()


# ------------------------------------------------------------------------------
# Private methods
# ------------------------------------------------------------------------------


func _on_scene_node_added(p_node: Node) -> void:
	if not p_node is SoundBank:
		return
		
	_add_bank(p_node)
	
	
func _on_scene_node_removed(p_node: Node) -> void:
	if not p_node is SoundBank:
		return
		
	_remove_bank(p_node)


func _initialise_pool(p_size: int, p_creator_fn: Callable) -> void:
	for i in p_size:
		p_creator_fn.call_deferred()


func _auto_add_events() -> void:
	var sound_banks = ResonateUtils.find_all_nodes(self, "SoundBank")
	
	for sound_bank in sound_banks:
		_add_bank(sound_bank)
		
	_event_table_hash = _event_table.hash()
		

func _add_bank(p_bank: SoundBank) -> void:
	if _event_table.has(p_bank.label):
		_event_table[p_bank.label]["ref_count"] = \
				_event_table[p_bank.label]["ref_count"] + 1
		
		return
		
	_event_table[p_bank.label] = {
		"name": p_bank.label,
		"bus": p_bank.bus,
		"mode": p_bank.mode,
		"events": _create_events(p_bank.events),
		"ref_count": 1,
	}
	

func _remove_bank(p_bank: SoundBank) -> void:
	if not _event_table.has(p_bank.label):
		return
	
	if _event_table[p_bank.label]["ref_count"] == 1:
		_event_table.erase(p_bank.label)
		return
	
	_event_table[p_bank.label]["ref_count"] = \
			_event_table[p_bank.label]["ref_count"] - 1
	

func _create_events(p_events: Array[SoundEventResource]) -> Dictionary:
	var events = {}
	
	for event in p_events:
		events[event.name] = {
			"name": event.name,
			"bus": event.bus,
			"volume": event.volume,
			"pitch": event.pitch,
			"streams": event.streams,
		}
		
	return events


func _get_bus(p_bank_bus: String, p_event_bus: String) -> String:
	if p_event_bus != null and p_event_bus != "":
		return p_event_bus
	
	if p_bank_bus != null and p_bank_bus != "":
		return p_bank_bus
		
	return ProjectSettings.get_setting(
		_settings.SOUND_BANK_BUS_SETTING_NAME,
		_settings.SOUND_BANK_BUS_SETTING_DEFAULT)


func _instance_manual(p_bank_label: String, p_event_name: String, p_reserved: bool = false, p_bus: String = "", p_poly: bool = false, p_attachment = null) -> Variant:
	if not has_loaded:
		push_error("Resonate - The event [%s] on bank [%s] can't be instanced as the SoundManager has not loaded yet. Use the [loaded] signal/event to determine when it is ready." % [p_event_name, p_bank_label])
		return _get_null_player(p_attachment)
		
	if not _event_table.has(p_bank_label):
		push_error("Resonate - Tried to instance the event [%s] from an unknown bank [%s]." % [p_event_name, p_bank_label])
		return _get_null_player(p_attachment)
		
	if not _event_table[p_bank_label]["events"].has(p_event_name):
		push_error("Resonate - Tried to instance an unknown event [%s] from the bank [%s]." % [p_event_name, p_bank_label])
		return _get_null_player(p_attachment)
	
	var bank = _event_table[p_bank_label] as Dictionary
	var event = bank["events"][p_event_name] as Dictionary
	
	if event.streams.size() == 0:
		push_error("Resonate - The event [%s] on bank [%s] has no streams, you'll need to add one at minimum." % [p_event_name, p_bank_label])
		return _get_null_player(p_attachment)
		
	var player = _get_player(p_attachment)
	
	if player == null:
		push_warning("Resonate - The event [%s] on bank [%s] can't be instanced; no pooled players available." % [p_event_name, p_bank_label])
		return _get_null_player(p_attachment)
		
	var bus = p_bus if p_bus != "" else _get_bus(bank.bus, event.bus)
	
	player.configure(event.streams, p_reserved, bus, p_poly, event.volume, event.pitch, bank.mode)
	player.attach_to(p_attachment)
	
	return player


func _is_player_free(p_player) -> bool:
	return not p_player.playing and not p_player.reserved


func _get_player_from_pool(p_pool: Array) -> Variant:
	if p_pool.size() == 0:
		push_error("Resonate - Player pool has not been initialised. This can occur when calling a [play/instance*] function from [_ready].")
		return null
	
	for player in p_pool:
		if _is_player_free(player):
			return player
	
	push_warning("Resonate - Player pool exhausted, consider increasing the pool size in the project settings (Audio/Manager/Pooling) or releasing unused audio stream players.")
	return null
	

func _get_player_1d() -> PooledAudioStreamPlayer:
	return _get_player_from_pool(_1d_players)
	

func _get_player_2d() -> PooledAudioStreamPlayer2D:
	return _get_player_from_pool(_2d_players)
	

func _get_player_3d() -> PooledAudioStreamPlayer3D:
	return _get_player_from_pool(_3d_players)


func _get_player(p_attachment = null) -> Variant:
	if ResonateUtils.is_2d_node(p_attachment):
		return _get_player_2d()
	
	if ResonateUtils.is_3d_node(p_attachment):
		return _get_player_3d()
		
	return _get_player_1d()


func _get_null_player(p_attachment = null) -> Variant:
	if ResonateUtils.is_2d_node(p_attachment):
		return null_instance_2d()
	
	if ResonateUtils.is_3d_node(p_attachment):
		return null_instance_3d()
		
	return null_instance()


func _add_player_to_pool(p_player, p_pool) -> Variant:
	add_child(p_player)
	
	p_player.released.connect(_on_player_released.bind(p_player))
	p_player.finished.connect(_on_player_finished.bind(p_player))
	p_pool.append(p_player)
	
	return p_player


func _create_player_1d() -> PooledAudioStreamPlayer:
	return _add_player_to_pool(PooledAudioStreamPlayer.create(), _1d_players)
	

func _create_player_2d() -> PooledAudioStreamPlayer2D:
	return _add_player_to_pool(PooledAudioStreamPlayer2D.create(), _2d_players)
	
	
func _create_player_3d() -> PooledAudioStreamPlayer3D:
	return _add_player_to_pool(PooledAudioStreamPlayer3D.create(), _3d_players)


func _on_player_released(p_player: Node) -> void:
	if p_player.playing:
		return
	
	pools_updated.emit()
	updated.emit()
	

func _on_player_finished(p_player: Node) -> void:
	if p_player.reserved:
		return
		
	pools_updated.emit()
	updated.emit()
