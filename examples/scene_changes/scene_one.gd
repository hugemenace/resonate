extends Node2D


@onready var timer: Timer = $Timer

var _instance: PooledAudioStreamPlayer
var _music_playing: bool


func _ready():
	MusicManager.loaded.connect(on_music_manager_updated)
	MusicManager.banks_updated.connect(on_music_manager_updated)
	
	SoundManager.loaded.connect(on_sound_manager_updated)
	SoundManager.banks_updated.connect(on_sound_manager_updated)
	
	timer.timeout.connect(on_timer_timeout)


func _exit_tree():
	if _instance == null:
		return
		
	_instance.release()


func on_music_manager_updated() -> void:
	if _music_playing or not MusicManager.has_loaded:
		return
	
	MusicManager.set_volume(-10)
	MusicManager.play("scene_one", "track_a", 0)
	
	_music_playing = true
	
	
func on_sound_manager_updated() -> void:
	if _instance != null or not SoundManager.has_loaded:
		return
		
	_instance = SoundManager.instance("scene_one", "note")
	

func on_timer_timeout() -> void:
	if _instance == null or not SoundManager.has_loaded:
		return
		
	_instance.trigger()
