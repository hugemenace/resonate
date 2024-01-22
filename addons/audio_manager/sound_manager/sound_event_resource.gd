class_name SoundEventResource
extends Resource


@export var name: String
@export var bus: String
@export var streams: Array[AudioStream]


func _init(p_name := "", p_streams := []):
	name = p_name
	streams.assign(p_streams)
