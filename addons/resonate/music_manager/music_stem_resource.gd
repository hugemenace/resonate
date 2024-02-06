class_name MusicStemResource
extends Resource


@export var name: String = ""
@export var enabled: bool = false
@export_range(-80.0, 6.0, 0.1, "suffix:dB") var volume: float = 0.0
@export var stream: AudioStream
