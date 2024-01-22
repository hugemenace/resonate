class_name PooledAudioStreamPlayer
extends AudioStreamPlayer


signal released(p_player: Node)

var reserved: bool
var poly: bool
var streams: Array


func _ready() -> void:
	finished.connect(on_finished)
	

func configure(p_streams: Array, p_bus: String, p_poly: bool) -> void:
	var is_polyphonic = PoolEntity.configure(self, p_streams, p_bus, p_poly)
	
	if is_polyphonic:
		super.play()
	

func trigger(p_auto_release: bool = false) -> void:
	var should_play = PoolEntity.trigger(self, p_auto_release)
	
	if should_play:
		super.play()


func release() -> void:
	reserved = false
	released.emit(self)


func on_finished() -> void:
	if reserved:
		return
		
	release()
