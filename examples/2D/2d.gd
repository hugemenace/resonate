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
	# The SoundManager's play_on_node and instance_on_node functions are designed
	# so that you can pass them any Node2D or Node3D class (or child thereof)
	# and they'll automatically detect whether the player should be spawned
	# in 2D or 3D space. It'll also return the appropriate Pooled* player.
	SoundManager.play_on_node("2d", "drums", moving_target)
