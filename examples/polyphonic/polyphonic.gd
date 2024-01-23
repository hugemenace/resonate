extends Node2D


# To understand this example completely, take a look at the SoundBank child node
# on this scene. The sound bank contains a single event (SoundEventResource) 
# which contains a single variation (audio stream) that will play when the 
# event is triggered. This allows for less repetitive sounding events.


var _sound_ready: bool = false
var _instance: PooledAudioStreamPlayer


func _ready() -> void:
	# As the SoundManager requires some time to set things up behind the scenes,
	# it's advised that you connect via its "loaded" event before triggering
	# sounds. In this script we're using _sound_ready to mark it as ready.
	SoundManager.loaded.connect(on_sound_manager_loaded)
	

func _input(p_event: InputEvent) -> void:
	if not _sound_ready:
		return
		
	if p_event.is_action_pressed("one"):
		# To play a reserved event, call the trigger function on the event instance,
		# which in this case is a PooledAudioStreamPlayer. Calling the base play() 
		# function will not work as expected, so trigger() must be called instead.
		_instance.trigger()
		
	if p_event.is_action_pressed("two"):
		# To play a reserved event, call the trigger function on the event instance,
		# which in this case is a PooledAudioStreamPlayer. Calling the base play() 
		# function will not work as expected, so trigger() must be called instead.
		_instance.trigger_varied(randf_range(0.9, 1.2), randf_range(-2.0, 0.0))


func on_sound_manager_loaded() -> void:
	_sound_ready = true
	
	# When calling any of the instance* functions, you'll be given back the 
	# underlying PooledAudioStreamPlayer* class, and the event will not be 
	# automatically triggered (played). This allows you to easily alter 
	# variables such as pitch and volume dynamically, while also reserving 
	# it for future use. If you want to return the player to the pool, you'll
	# need to call the release() function on it which will handle the process.
	_instance = SoundManager.instance_poly("polyphonic", "blaster")
