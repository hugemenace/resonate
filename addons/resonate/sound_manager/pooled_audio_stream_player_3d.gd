class_name PooledAudioStreamPlayer3D
extends AudioStreamPlayer3D


signal released

var reserved: bool
var releasing: bool
var poly: bool
var streams: Array
var base_volume: float
var base_pitch: float


func _ready() -> void:
	finished.connect(on_finished)
	

static func create() -> PooledAudioStreamPlayer3D:
	return PoolEntity.create(PooledAudioStreamPlayer3D.new())


func is_null() -> bool:
	return false


func configure(p_streams: Array, p_reserved: bool, p_bus: String, p_poly: bool, p_volume: float, p_pitch: float, p_mode: Node.ProcessMode) -> void:
	var is_polyphonic = PoolEntity.configure(self, p_streams, p_reserved, p_bus, p_poly, p_volume, p_pitch, p_mode)
	
	if is_polyphonic:
		super.play()
	

func trigger() -> void:
	var should_play = PoolEntity.trigger(self, false, 1.0, 0.0)
	
	if should_play:
		super.play()
		

func trigger_varied(p_pitch: float = 1.0, p_volume: float = 0.0) -> void:
	var should_play = PoolEntity.trigger(self, true, p_pitch, p_volume)
	
	if should_play:
		super.play()
		

func reset_volume() -> void:
	PoolEntity.reset_volume(self)
	
	
func reset_pitch() -> void:
	PoolEntity.reset_pitch(self)
	

func reset_all() -> void:
	PoolEntity.reset_all(self)


func release(p_finish_playing: bool = false) -> void:
	PoolEntity.release(self, p_finish_playing)


func on_finished() -> void:
	PoolEntity.finished(self)
