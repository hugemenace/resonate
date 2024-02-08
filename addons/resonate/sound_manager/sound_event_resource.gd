class_name SoundEventResource
extends Resource
## The container used to store the details of a sound event.


## This sound event's unique identifier.
@export var name: String = ""

## The bus to use for all sound events in this bank.[br][br]
## [b]Note:[/b] this will override the bus set in this events sound bank, 
## or your project settings (Audio/Manager/Sound/Bank)
@export var bus: String = ""

## The volume of the sound event.
@export_range(-80.0, 6.0, 0.1, "suffix:dB") var volume: float = 0.0

## The pitch of the sound event.
@export var pitch: float = 1.0

## The collection of audio streams (variations) associated with this sound event.
@export var streams: Array[AudioStream]
