extends Node2D


# For reference, it's worth taking a moment to inspect the SoundBank attached to 
# this example scene. SoundBanks hold the configuration for all of your sound 
# events and the variations (AudioStreams) associated with the event.


@onready var timer: Timer = $Timer

# We instantiate a Null PooledAudioStreamPlayer* here, which removes the need to
# perform null checks before calling methods such as trigger() in your scripts.
var _instance: PooledAudioStreamPlayer = SoundManager.null_instance()


func _ready():
	# As the SoundManager requires some preparation when the game loads, we need 
	# to hook into one or more of its lifecycle events before trying to play or 
	# instance an audio event. In this example, we've use the `updated` event 
	# as it's fired whenever any part of the SoundManager's state updates.
	SoundManager.updated.connect(on_sound_manager_updated)
	
	timer.timeout.connect(on_timer_timeout)


func on_sound_manager_updated() -> void:
	# The method call below is an inbuilt guard-clause that'll help us avoid 
	# instancing an audio event when the SoundManager has not loaded, or when 
	# we've already replaced our Null instance with a real one further down.
	if SoundManager.should_skip_instancing(_instance):
		return

	_instance = SoundManager.instance("scene_two", "note")

	# If you know that a scene will be inserted or removed at runtime, and you
	# don't want to hook into lifecycle events to ensure your instances are
	# being released, you can instruct the SoundManager to do it for you.
	SoundManager.release_on_exit(self, _instance, true)


func on_timer_timeout():
	_instance.trigger()
