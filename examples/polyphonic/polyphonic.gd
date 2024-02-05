extends Node2D


# For reference, it's worth taking a moment to inspect the SoundBank attached to 
# this example scene. SoundBanks hold the configuration for all of your sound 
# events and the variations (AudioStreams) associated with the event.


# We instantiate a Null PooledAudioStreamPlayer* here, which removes the need to
# perform null checks before calling methods such as trigger() in your scripts.
var _instance: PooledAudioStreamPlayer = SoundManager.null_instance()


func _ready() -> void:
	# As the SoundManager requires some preparation when the game loads, we need 
	# to hook into one or more of its lifecycle events before trying to play or 
	# instance an audio event. In this example, we've use the `updated` event 
	# as it's fired whenever any part of the SoundManager's state updates.
	SoundManager.updated.connect(on_sound_manager_updated)
	

func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("one"):
		_instance.trigger()
		
	if p_event.is_action_pressed("two"):
		_instance.trigger_varied(randf_range(0.9, 1.2), randf_range(-2.0, 0.0))


func on_sound_manager_updated() -> void:
	# The method call below is an inbuilt guard-clause that'll help us avoid 
	# instancing an audio event when the SoundManager has not loaded, or when 
	# we've already replaced our Null instance with a real one further down.
	if SoundManager.should_skip_instancing(_instance):
		return
	
	_instance = SoundManager.instance_poly("polyphonic", "blaster")
