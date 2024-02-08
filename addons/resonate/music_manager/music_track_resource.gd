class_name MusicTrackResource
extends Resource
## A container used to store the details of a music track and all of its corresponding stems.


## This track's unique identifier within the scope of the bank it belongs to.
@export var name: String = ""

## The bus to use for this particular track.[br][br]
## [b]Note:[/b] this will override the bus set on the bank, or in your project settings (Audio/Manager/Music/Bank)
@export var bus: String = ""

## The collection of stems that make up this track.
@export var stems: Array[MusicStemResource]
