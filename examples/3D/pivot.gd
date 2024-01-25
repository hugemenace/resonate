extends Node3D


func _process(p_delta):
	rotate_y(TAU * p_delta * 0.1)
