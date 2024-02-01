extends Node2D


@onready var timer: Timer = $Timer

var _is_playing_music: bool


func _ready():
	MusicManager.loaded.connect(on_music_manager_updated)
	MusicManager.banks_updated.connect(on_music_manager_updated)


func on_music_manager_updated() -> void:
	if _is_playing_music or not MusicManager.has_loaded:
		return
	
	MusicManager.play("scene_one", "track_a")
	
	# Calling auto_stop here ensures that when this particular node exits
	# the scene tree the music track stops playing. This would be 
	# equivalent to stopping the track in _exit_tree or @tree_exiting.
	MusicManager.auto_stop(self, "scene_one", "track_a")
	
	_is_playing_music = true
