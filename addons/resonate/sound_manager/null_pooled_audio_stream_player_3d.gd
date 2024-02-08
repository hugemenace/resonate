class_name NullPooledAudioStreamPlayer3D
extends PooledAudioStreamPlayer3D
## An extension of PooledAudioStreamPlayer3D that nerfs all of its public methods.


## Whether this player is a [PooledAudioStreamPlayer3D], or a Null instance.
func is_null() -> bool:
	return true


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer3D.trigger]
func trigger() -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer3D.trigger_varied]
func trigger_varied(p_pitch: float = 1.0, p_volume: float = 0.0) -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer3D.reset_volume]
func reset_volume() -> void:
	return
	

## A nerfed (does nothing) version of [method PooledAudioStreamPlayer3D.reset_pitch]
func reset_pitch() -> void:
	return
	

## A nerfed (does nothing) version of [method PooledAudioStreamPlayer3D.reset_all]
func reset_all() -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer3D.release]
func release(p_finish_playing: bool = false) -> void:
	return
