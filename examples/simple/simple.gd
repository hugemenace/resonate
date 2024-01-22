extends Node2D


# To understand this example completely, take a look at the SoundBank child node
# on this scene. The sound bank contains a single event (SoundEventResource) 
# which contains three variations (audio streams) that will play randomly 
# when the event is triggered. This allows for less repetitive events.


func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("one"):
		# To trigger an event, call the play function with the name of the 
		# sound bank as the first parameter, followed by the name of the
		# event. Every event requires at least one audio stream to work.
		SoundManager.play("example", "note")
