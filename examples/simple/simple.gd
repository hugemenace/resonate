extends Node2D


# For reference, it's worth taking a moment to inspect the SoundBank attached to 
# this example scene. SoundBanks hold the configuration for all of your sound 
# events and the variations (AudioStreams) associated with the event.


func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("one"):
		SoundManager.play("simple", "note")
		
	if p_event.is_action_pressed("two"):
		SoundManager.play_varied("simple", "note", randf_range(0.8, 1.2), randf_range(-8, 0))
