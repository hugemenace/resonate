extends Node2D


# To understand this example completely, take a look at the SoundBank child node
# on this scene. The sound bank contains a single event (SoundEventResource) 
# containing three variations (audio streams) that will play randomly when 
# the event is triggered. This allows for less repetitive sounding events.


func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("one"):
		# To trigger an event, call the play function with the name of the 
		# sound bank as the first parameter, followed by the name of the
		# event. Every event requires at least one audio stream to work.
		SoundManager.play("simple", "note")
		
	if p_event.is_action_pressed("two"):
		# To trigger an event with varied pitch and volume, call the play_varied
		# function with an additional pitch and volume setting. These will only
		# apply to play_varied, with further calls to play using the defaults.
		SoundManager.play_varied("simple", "note", randf_range(0.8, 1.2), randf_range(-8, 0))
