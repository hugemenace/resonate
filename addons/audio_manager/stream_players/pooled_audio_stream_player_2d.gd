class_name PooledAudioStreamPlayer2D
extends AudioStreamPlayer2D


signal released(p_player: Node)

var pool_type: SoundManager.pool_type
var reserved: bool
var poly: bool
var streams: Array


func _ready() -> void:
	finished.connect(on_finished)


static func create(p_type: SoundManager.pool_type) -> PooledAudioStreamPlayer2D:
	var player = PooledAudioStreamPlayer2D.new()
	player.pool_type = p_type
	
	return player
	

func configure(p_streams: Array, p_bus: String, p_poly: bool) -> void:
	var is_polyphonic = PoolEntity.configure(self, p_streams, p_bus, p_poly)
	
	if is_polyphonic:
		super.play()
	

func trigger(p_auto_release: bool = false) -> void:
	var should_play = PoolEntity.trigger(self, false, 1.0, 0.0, p_auto_release)
	
	if should_play:
		super.play()
		

func trigger_varied(p_pitch: float = 1.0, p_volume: float = 0.0, p_auto_release: bool = false) -> void:
	var should_play = PoolEntity.trigger(self, true, p_pitch, p_volume, p_auto_release)
	
	if should_play:
		super.play()


func release() -> void:
	reserved = false
	released.emit(self)


func on_finished() -> void:
	if reserved:
		return
		
	release()
