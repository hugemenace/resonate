class_name ResonateUtils
extends RefCounted


static func is_stream_looped(p_stream) -> bool:
	if p_stream is AudioStreamMP3:
		return p_stream.loop
		
	if p_stream is AudioStreamOggVorbis:
		return p_stream.loop
		
	if p_stream is AudioStreamWAV:
		return p_stream.loop_mode != AudioStreamWAV.LOOP_DISABLED
		
	return false


static func find_all_nodes(p_base: Node, p_type: String) -> Array:
	var root_nodes = p_base.get_tree().root.get_children()
	var results = []
	
	for node in root_nodes:
		results.append_array(node.find_children("*", p_type))
		
	return results
