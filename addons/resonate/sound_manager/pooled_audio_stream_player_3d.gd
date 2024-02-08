class_name PooledAudioStreamPlayer3D
extends AudioStreamPlayer3D
## An extension of AudioStreamPlayer3D that manages sequential and 
## polyphonic playback as part of a pool of players.


## Emitted when this player has been released and should return to the pool.
signal released

## Whether this player has been reserved.
var reserved: bool

## Whether this player is in the process of being released.
var releasing: bool

## Whether this player has been configured to support polyphonic playback.
var poly: bool

## The collection of streams configured on this player.
var streams: Array

## The base/fallback volume of this player.
var base_volume: float

## The base/fallback pitch of this player.
var base_pitch: float


# ------------------------------------------------------------------------------
# Lifecycle methods
# ------------------------------------------------------------------------------


func _ready() -> void:
	finished.connect(_on_finished)


# ------------------------------------------------------------------------------
# Public methods
# ------------------------------------------------------------------------------


## Returns a new player.
static func create() -> PooledAudioStreamPlayer3D:
	return PoolEntity.create(PooledAudioStreamPlayer3D.new())


## Whether this player is a [NullPooledAudioStreamPlayer3D], or real instance.
func is_null() -> bool:
	return false


## Configure this player with the given streams and charateristics.
func configure(p_streams: Array, p_reserved: bool, p_bus: String, p_poly: bool, p_volume: float, p_pitch: float, p_mode: Node.ProcessMode) -> void:
	var is_polyphonic = PoolEntity.configure(self, p_streams, p_reserved, p_bus, p_poly, p_volume, p_pitch, p_mode)
	
	if is_polyphonic:
		super.play()


## Trigger (play) a random variation associated with this player.
func trigger() -> void:
	var should_play = PoolEntity.trigger(self, false, 1.0, 0.0)
	
	if should_play:
		super.play()


## Trigger (play) a random variation associated with this
## player with the given volume and pitch settings.
func trigger_varied(p_pitch: float = 1.0, p_volume: float = 0.0) -> void:
	var should_play = PoolEntity.trigger(self, true, p_pitch, p_volume)
	
	if should_play:
		super.play()


## Reset the volume of this player back to the default set in its bank.
func reset_volume() -> void:
	PoolEntity.reset_volume(self)
	

## Reset the pitch of this player back to the default set in its bank.
func reset_pitch() -> void:
	PoolEntity.reset_pitch(self)
	

## Reset both the volume and pitch of this player back to the default set in its bank.
func reset_all() -> void:
	PoolEntity.reset_all(self)


## Release this player back to the pool, and optionally
## wait for it to finish playing before doing so.
func release(p_finish_playing: bool = false) -> void:
	PoolEntity.release(self, p_finish_playing)


# ------------------------------------------------------------------------------
# Private methods
# ------------------------------------------------------------------------------


func _on_finished() -> void:
	PoolEntity.finished(self)
