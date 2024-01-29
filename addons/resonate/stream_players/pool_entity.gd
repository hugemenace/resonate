class_name PoolEntity
extends RefCounted


static func create(p_base, p_type) -> Variant:
	p_base.pool_type = p_type
	p_base.process_mode = Node.PROCESS_MODE_ALWAYS
	
	return p_base


static func configure(p_base, p_streams: Array, p_reserved: bool, p_bus: String, p_poly: bool, p_mode: Node.ProcessMode) -> bool:
	p_base.streams = p_streams
	p_base.poly = p_poly
	p_base.bus = p_bus
	p_base.process_mode = p_mode
	p_base.reserved = p_reserved
	
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
	
	if not p_base.poly:
		if p_varied:
			p_base.volume = p_volume
			p_base.pitch_scale = p_pitch
		p_base.stream = next_stream
		return true
	
	var playback = p_base.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(next_stream, 0, p_volume, p_pitch)
	
	return false


static func release(p_base) -> void:
	p_base.reserved = false
	p_base.process_mode = Node.PROCESS_MODE_ALWAYS
	p_base.released.emit()


static func finished(p_base) -> void:
	if p_base.reserved:
		return
		
	p_base.release()
