class_name PoolEntity
extends RefCounted


static func create(p_base) -> Variant:
	p_base.process_mode = Node.PROCESS_MODE_ALWAYS
	
	return p_base


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
	
	if not p_base.poly:
		return false
	
	var max_polyphony = ProjectSettings.get_setting(
		ResonatePlugin.MAX_POLYPHONY_SETTING_NAME,
		ResonatePlugin.MAX_POLYPHONY_SETTING_DEFAULT)
	
	p_base.stream = AudioStreamPolyphonic.new()
	p_base.max_polyphony = max_polyphony
	p_base.stream.polyphony = max_polyphony
	
	return true


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


static func reset_volume(p_base) -> void:
	p_base.volume_db = p_base.base_volume
	

static func reset_pitch(p_base) -> void:
	p_base.pitch_scale = p_base.base_pitch
	

static func reset_all(p_base) -> void:
	p_base.volume_db = p_base.base_volume
	p_base.pitch_scale = p_base.base_pitch


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


static func finished(p_base) -> void:
	if p_base.reserved:
		return
		
	p_base.release()
