class_name MusicBank
extends Node
## A container used to store & group music tracks in your scene.


## This bank's unique identifier.
@export var label: String

## The bus to use for all tracks played from this bank.[br][br]
## [b]Note:[/b] this will override the bus set in your project settings (Audio/Manager/Music/Bank)
@export var bus: String

## The underlying process mode for all tracks played from this bank.
@export var mode: Node.ProcessMode

## The collection of tracks associated with this bank.
@export var tracks: Array[MusicTrackResource]
