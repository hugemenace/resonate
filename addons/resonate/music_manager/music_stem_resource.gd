class_name MusicStemResource
extends Resource
## A container used to store the details of one particular music track's stem.


## This stem's unique identifier within the scope of the track it belongs to.
@export var name: String = ""

## Whether this stem will start playing automatically when the track starts.
@export var enabled: bool = false

## The volume of the stem.
@export_range(-80.0, 6.0, 0.1, "suffix:dB") var volume: float = 0.0

## The audio stream associated with this stem.
@export var stream: AudioStream
