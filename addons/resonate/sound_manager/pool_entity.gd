class_name PoolEntity
extends RefCounted
## An abstract/static class to house all of the common PooledAudioStreamPlayer* functionality.


const ResonateSettings = preload("../shared/resonate_settings.gd")

enum FollowType {DISABLED, IDLE, PHYSICS}


## Create a new PooledAudioStreamPlayer*.
static func create(p_base) -> Variant:
	p_base.process_mode = Node.PROCESS_MODE_ALWAYS
	
	return p_base


## Configure a PooledAudioStreamPlayer*.
static func configure(p_base, p_streams: Array, p_reserved: bool, p_bus: String, p_poly: bool, p_volume: float, p_pitch: float, p_mode: Node.ProcessMode) -> bool:
	p_base.streams = p_streams
	p_base.poly = p_poly
	p_base.bus = p_bus
	p_base.process_mode = p_mode
	p_base.reserved = p_reserved
	p_base.releasing = false
	p_base.volume_db = p_volume if not p_poly else 0.0
	p_base.pitch_scale = p_pitch if not p_poly else 1.0
	p_base.base_volume = p_volume
	p_base.base_pitch = p_pitch
	p_base.follow_target = null
	p_base.follow_type = FollowType.DISABLED
	
	if not p_base.poly:
		return false
	
	var _settings = ResonateSettings.new()
	
	var max_polyphony = ProjectSettings.get_setting(
		_settings.MAX_POLYPHONY_SETTING_NAME,
		_settings.MAX_POLYPHONY_SETTING_DEFAULT)
	
	p_base.stream = AudioStreamPolyphonic.new()
	p_base.max_polyphony = max_polyphony
	p_base.stream.polyphony = max_polyphony
	
	return true


## Attach a PooledAudioStreamPlayer* to a position or node.
static func attach_to(p_base, p_node: Variant) -> void:
	if p_node == null:
		return
	
	if ResonateUtils.is_vector(p_node):
		p_base.global_position = p_node
	
	if ResonateUtils.is_node(p_node):
		p_base.follow_target = p_node
		p_base.follow_type = FollowType.IDLE


## Sync a PooledAudioStreamPlayer*'s transform with its target's when applicable. 
static func sync_process(p_base) -> void:
	if p_base.follow_target == null:
		return
		
	if not is_instance_valid(p_base.follow_target):
		return
		
	if p_base.follow_type != FollowType.IDLE:
		return
	
	p_base.global_position = p_base.follow_target.global_position
	

## Sync a PooledAudioStreamPlayer*'s transform with its target's
## when applicable during the physics step. 
static func sync_physics_process(p_base) -> void:
	if p_base.follow_target == null:
		return
		
	if not is_instance_valid(p_base.follow_target):
		return
		
	if p_base.follow_type != FollowType.PHYSICS:
		return
	
	p_base.global_position = p_base.follow_target.global_position


## Trigger a PooledAudioStreamPlayer*.
static func trigger(p_base, p_varied: bool, p_pitch: float, p_volume: float) -> bool:
	if p_base.streams.size() == 0:
		push_warning("Resonate - The player [%s] does not contain any streams, ensure you're using the SoundManager to instance it correctly." % p_base.name)
		return false
		
	var next_stream = p_base.streams.pick_random()
	
	if not p_base.poly and p_varied:
		p_base.volume_db = p_volume
		p_base.pitch_scale = p_pitch
	
	if not p_base.poly:
		p_base.stream = next_stream
		return true
	
	var playback = p_base.get_stream_playback() as AudioStreamPlaybackPolyphonic
	
	if p_varied:
		playback.play_stream(next_stream, 0, p_volume, p_pitch)
	else:
		playback.play_stream(next_stream, 0, p_base.base_volume, p_base.base_pitch)
	
	return false


## Reset the volume of a PooledAudioStreamPlayer*.
static func reset_volume(p_base) -> void:
	p_base.volume_db = p_base.base_volume
	

## Reset the pitch of a PooledAudioStreamPlayer*.
static func reset_pitch(p_base) -> void:
	p_base.pitch_scale = p_base.base_pitch
	

## Reset both the volume and pitch of a PooledAudioStreamPlayer*.
static func reset_all(p_base) -> void:
	p_base.volume_db = p_base.base_volume
	p_base.pitch_scale = p_base.base_pitch


## Release a PooledAudioStreamPlayer* back into the pool.
static func release(p_base, p_finish_playing: bool) -> void:
	if p_base.releasing:
		return
		
	var has_loops = p_base.streams.any(ResonateUtils.is_stream_looped)
	
	if p_finish_playing and has_loops:
		push_warning("Resonate - The player [%s] has looping streams and therefore will never release itself back to the pool (as playback continues indefinitely). It will be forced to stop." % p_base.name)
		p_base.stop()
		
	if not p_finish_playing:
		p_base.stop()
		
	p_base.reserved = false
	p_base.process_mode = Node.PROCESS_MODE_ALWAYS
	p_base.releasing = true
	p_base.released.emit()


## A callback to release a PooledAudioStreamPlayer* when it finishes playing.
static func finished(p_base) -> void:
	if p_base.reserved:
		return
		
	p_base.release()
