extends Label


var _size_1d: int = 0
var _size_2d: int = 0
var _size_3d: int = 0


func _ready() -> void:
	text = "Pool stats loading..."
	
	SoundManager.loaded.connect(on_sound_manager_loaded)
	
	# The SoundManager offers a "pool_updated" event that you can use to determine
	# when a 1D, 2D, or 3D player pool has been updated and how many players in
	# the pool are free to use. However, it's not required for standard use.
	SoundManager.pool_updated.connect(on_sound_manager_pool_updated)


func _process(_p_delta) -> void:
	text = """SoundManager:
	  -  Player pool size (1D): %s
	  -  Player pool size (2D): %s
	  -  Player pool size (3D): %s""" % [_size_1d, _size_2d, _size_3d]


func on_sound_manager_loaded() -> void:
	_size_1d = SoundManager.get_pool_size(SoundManager.pool_type.ONE_D)
	_size_2d = SoundManager.get_pool_size(SoundManager.pool_type.TWO_D)
	_size_3d = SoundManager.get_pool_size(SoundManager.pool_type.THREE_D)


func on_sound_manager_pool_updated(p_type: SoundManager.pool_type, p_size: int) -> void:
	if p_type == SoundManager.pool_type.ONE_D:
		_size_1d = p_size
		
	if p_type == SoundManager.pool_type.TWO_D:
		_size_2d = p_size
		
	if p_type == SoundManager.pool_type.THREE_D:
		_size_3d = p_size
