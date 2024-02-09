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


static func is_vector(p_node: Variant) -> bool:
	return p_node is Vector2 or p_node is Vector3
	

static func is_node(p_node: Variant) -> bool:
	return p_node is Node2D or p_node is Node3D
	

static func is_2d_node(p_node: Variant) -> bool:
	return p_node is Vector2 or p_node is Node2D


static func is_3d_node(p_node: Variant) -> bool:
	return p_node is Vector3 or p_node is Node3D
