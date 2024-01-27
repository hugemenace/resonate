class_name PooledAudioStreamPlayer2D
extends AudioStreamPlayer2D


signal released

var pool_type: SoundManager.PoolType
var reserved: bool
var poly: bool
var streams: Array


func _ready() -> void:
	finished.connect(on_finished)


static func create(p_type: SoundManager.PoolType) -> PooledAudioStreamPlayer2D:
	var player = PooledAudioStreamPlayer2D.new()
	
	player.pool_type = p_type
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	return player
	

func configure(p_streams: Array, p_bus: String, p_poly: bool, p_mode: Node.ProcessMode) -> void:
	var is_polyphonic = PoolEntity.configure(self, p_streams, p_bus, p_poly, p_mode)
	
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
	process_mode = Node.PROCESS_MODE_ALWAYS
	released.emit()


func on_finished() -> void:
	if reserved:
		return
		
	release()