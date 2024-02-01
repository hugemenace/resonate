extends Node2D


@onready var timer: Timer = $Timer

var _instance: PooledAudioStreamPlayer


func _ready():
	SoundManager.loaded.connect(on_sound_manager_updated)
	SoundManager.banks_updated.connect(on_sound_manager_updated)
	
	timer.timeout.connect(on_timer_timeout)


func on_sound_manager_updated() -> void:
	if _instance != null or not SoundManager.has_loaded:
		return
		
	_instance = SoundManager.instance("scene_two", "note")
	
	# Calling auto_release here ensures that when this particular node exits
	# the scene tree the instance is automatically released. This would be
	# equivalent to releasing the instance in _exit_tree or @tree_exiting.
	SoundManager.auto_release(self, _instance)


func on_timer_timeout() -> void:
	if _instance == null or not SoundManager.has_loaded:
		return
		
	_instance.trigger()
