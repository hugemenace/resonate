class_name SoundBank
extends Node
## A container used to store & group sound events in your scene.


## This bank's unique identifier.
@export var label: String

## The bus to use for all sound events in this bank.[br][br]
## [b]Note:[/b] this will override the bus set in your project settings (Audio/Manager/Sound/Bank)
@export var bus: String

## The underlying process mode for all sound events in this bank.
@export var mode: Node.ProcessMode

## The collection of sound events associated with this bank.
@export var events: Array[SoundEventResource]
