extends Node2D


# For reference, it's worth taking a moment to inspect the SoundBank attached to 
# this example scene. SoundBanks hold the configuration for all of your sound 
# events and the variations (AudioStreams) associated with the event.


var _instance_note_one: PooledAudioStreamPlayer = SoundManager.null_instance()
var _instance_note_two: PooledAudioStreamPlayer = SoundManager.null_instance()
var _instance_note_three: PooledAudioStreamPlayer = SoundManager.null_instance()


func _ready() -> void:
	# As the SoundManager requires some preparation when the game loads, we need 
	# to hook into one or more of its lifecycle events before trying to play or 
	# instance an audio event. In this example, we've use the `updated` event 
	# as it's fired whenever any part of the SoundManager's state updates.
	SoundManager.updated.connect(on_sound_manager_updated)
	

func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("one"):
		_instance_note_one.trigger()
	
	if p_event.is_action_pressed("two"):
		_instance_note_two.trigger()
		
	if p_event.is_action_pressed("three"):
		_instance_note_three.trigger()


func on_sound_manager_updated() -> void:
	# We'll use the quick_instance method here as it'll take care of a number of
	# repetitive steps that would otherwise be necessary to set up all three 
	# instances. It also ensures that each instance is only registered once.
	
	_instance_note_one = SoundManager.quick_instance(_instance_note_one,
			SoundManager.instance.bind("bulk", "one"), self)
			
	_instance_note_two = SoundManager.quick_instance(_instance_note_two,
			SoundManager.instance.bind("bulk", "two"), self)
			
	_instance_note_three = SoundManager.quick_instance(_instance_note_three,
			SoundManager.instance.bind("bulk", "three"), self)
