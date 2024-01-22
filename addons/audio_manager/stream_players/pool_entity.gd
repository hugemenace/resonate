class_name PoolEntity
extends RefCounted


static func configure(p_base, p_streams: Array, p_bus: String, p_poly: bool) -> bool:
	p_base.streams = p_streams
	p_base.poly = p_poly
	p_base.bus = p_bus
	
	if not p_base.poly:
		return false
	
	var max_polyphony = ProjectSettings.get_setting(
		AudioManagerPlugin.MAX_POLYPHONY_SETTING_NAME,
		AudioManagerPlugin.MAX_POLYPHONY_SETTING_DEFAULT)
	
	p_base.stream = AudioStreamPolyphonic.new()
	p_base.max_polyphony = max_polyphony
	p_base.stream.polyphony = max_polyphony
	
	return true


static func trigger(p_base, p_auto_release: bool) -> bool:
	if p_base.streams.size() == 0:
		push_warning("AudioManager - The player [%s] does not contain any streams, ensure you're using the SoundManager to instance it correctly." % p_base.name)
		return false
		
	p_base.reserved = not p_auto_release
		
	var next_stream = p_base.streams.pick_random()
	
	if not p_base.poly:
		p_base.stream = next_stream
		return true
	
	var playback = p_base.get_stream_playback() as AudioStreamPlaybackPolyphonic
	playback.play_stream(next_stream)
	
	return false
