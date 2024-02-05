class_name SoundEventResource
extends Resource


@export var name: String
@export var bus: String
@export_range(-80.0, 6.0, 0.1, "suffix:dB") var volume: float
@export var streams: Array[AudioStream]


func _init(p_name := "", p_streams := []):
	name = p_name
	streams.assign(p_streams)
