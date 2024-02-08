class_name NullPooledAudioStreamPlayer
extends PooledAudioStreamPlayer
## An extension of PooledAudioStreamPlayer that nerfs all of its public methods.


## Whether this player is a [PooledAudioStreamPlayer], or a Null instance.
func is_null() -> bool:
	return true


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer.trigger]
func trigger() -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer.trigger_varied]
func trigger_varied(p_pitch: float = 1.0, p_volume: float = 0.0) -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer.reset_volume]
func reset_volume() -> void:
	return
	

## A nerfed (does nothing) version of [method PooledAudioStreamPlayer.reset_pitch]
func reset_pitch() -> void:
	return
	

## A nerfed (does nothing) version of [method PooledAudioStreamPlayer.reset_all]
func reset_all() -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer.release]
func release(p_finish_playing: bool = false) -> void:
	return
