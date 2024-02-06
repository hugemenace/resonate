class_name SoundEventResource
extends Resource


@export var name: String = ""
@export var bus: String = ""
@export_range(-80.0, 6.0, 0.1, "suffix:dB") var volume: float = 0.0
@export var pitch: float = 1.0
@export var streams: Array[AudioStream]
