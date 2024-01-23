extends Node2D


# To understand this example completely, take a look at the SoundBank child node
# on this scene. The sound bank contains a single event (SoundEventResource) 
# which contains three variations (audio streams) that will play randomly 
# when the event is triggered. This allows for less repetitive events.


var _sound_ready: bool = false


func _ready() -> void:
	# As the SoundManager requires some time to set things up behind the scenes,
	# it's advised that you connect via its "loaded" event before triggering
	# sounds. In this script we're _sound_ready to determine its status.
	SoundManager.loaded.connect(on_sound_manager_loaded)
	

func _input(p_event: InputEvent) -> void:
	if not _sound_ready:
		return
		
	if p_event.is_action_pressed("one"):
		# To trigger an event, call the play function with the name of the 
		# sound bank as the first parameter, followed by the name of the
		# event. Every event requires at least one audio stream to work.
		SoundManager.play("example", "note")


func on_sound_manager_loaded() -> void:
	_sound_ready = true
