extends Node2D


# To understand this example completely, take a look at the SoundBank child node
# on this scene. The sound bank contains a single event (SoundEventResource) 
# containing three variations (audio streams) that will play randomly when 
# the event is triggered. This allows for less repetitive sounding events.


@onready var note_interval = $NoteInterval
@onready var moving_target = $MovingTarget

var _sound_ready: bool = false
var _instance: PooledAudioStreamPlayer2D


func _ready() -> void:
	# As the SoundManager requires some time to set things up behind the scenes,
	# it's advised that you connect via its "loaded" event before triggering
	# sounds. In this script we're using _sound_ready to mark it as ready.
	SoundManager.loaded.connect(on_sound_manager_loaded)
	
	note_interval.timeout.connect(on_note_interval_timeout)


func on_note_interval_timeout() -> void:
	if not _sound_ready:
		return
	
	_instance.trigger()


func on_sound_manager_loaded() -> void:
	_sound_ready = true
	
	# The SoundManager's play_on_node and instance_on_node functions are designed
	# so that you can pass them any Node2D or Node3D class (or child thereof)
	# and they'll automatically detect whether the player should be spawned
	# in 2D or 3D space. It'll also return the appropriate Pooled* player.
	_instance = SoundManager.instance_on_node("2d", "note", moving_target)
