class_name MusicStemResource
extends Resource


@export var name: String
@export var enabled: bool
@export var stream: AudioStream


func _init(p_name := "", p_enabled := true, p_stream: AudioStream = null):
	name = p_name
	enabled = p_enabled
	stream = p_stream
