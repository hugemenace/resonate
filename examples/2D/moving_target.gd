extends MeshInstance2D


var _time: float


func _process(p_delta) -> void:
	_time += p_delta
	
	var weight = (1.0 + sin(_time)) / 2.0
	var x_position = lerpf(-100.0, 1300.0, weight)
	
	global_position.x = x_position
