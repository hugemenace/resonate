extends Node2D


# To understand this example completely, take a look at the SoundBank child node
# on this scene. The sound bank contains a single event (SoundEventResource) 
# containing three variations (audio streams) that will play randomly when 
# the event is triggered. This allows for less repetitive sounding events.


@onready var moving_target = $MovingTarget


func _ready() -> void:
	# As the SoundManager requires some time to set things up behind the scenes,
	# it's advised that you connect via its "loaded" event before triggering
	# sounds. In this script we're using _sound_ready to mark it as ready.
	SoundManager.loaded.connect(on_sound_manager_loaded)
	

func on_sound_manager_loaded() -> void:
	# As the sound event below is a loop, we need to instance and trigger it manually. 
	# Looped sounds are not automatically returned back to the pool as their playback 
	# never ends. If you attempt to play* an event with variations that are looped, 
	# you will not hear them and a warning will be emitted to the console.
	SoundManager.instance_on_node("2d", "drums", moving_target).trigger()
