class_name MusicResource
extends Resource


@export var name: String
@export var stems: Array[MusicStemResource]


func _init(p_name := "", p_stems := []):
	name = p_name
	stems.assign(p_stems)
