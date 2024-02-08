class_name NullPooledAudioStreamPlayer2D
extends PooledAudioStreamPlayer2D
## An extension of PooledAudioStreamPlayer2D that nerfs all of its public methods.


## Whether this player is a [PooledAudioStreamPlayer2D], or a Null instance.
func is_null() -> bool:
	return true


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer2D.trigger]
func trigger() -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer2D.trigger_varied]
func trigger_varied(p_pitch: float = 1.0, p_volume: float = 0.0) -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer2D.reset_volume]
func reset_volume() -> void:
	return
	

## A nerfed (does nothing) version of [method PooledAudioStreamPlayer2D.reset_pitch]
func reset_pitch() -> void:
	return
	

## A nerfed (does nothing) version of [method PooledAudioStreamPlayer2D.reset_all]
func reset_all() -> void:
	return


## A nerfed (does nothing) version of [method PooledAudioStreamPlayer2D.release]
func release(p_finish_playing: bool = false) -> void:
	return
