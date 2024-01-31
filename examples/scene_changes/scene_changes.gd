extends Node2D


@onready var scene_details = $SceneDetails

const _SCENE_NAMES: Array[String] = ["scene_one", "scene_two"]
const _SCENES: Dictionary = {
	"scene_one": preload("res://examples/scene_changes/scene_one.tscn"),
	"scene_two": preload("res://examples/scene_changes/scene_two.tscn"),
}

var _current_scene: int = 0
var _current_scene_ref: Node


func _ready() -> void:
	load_scene(_current_scene)
	

func _process(_p_delta) -> void:
	scene_details.text = "Current scene: %s" % _SCENE_NAMES[_current_scene]


func _input(p_event) -> void:
	if p_event.is_action_pressed("one"):
		_current_scene = _current_scene + 1 if (_current_scene + 1) < _SCENE_NAMES.size() else 0
		load_scene(_current_scene)


func load_scene(p_index: int) -> void:
	if _current_scene_ref != null:
		remove_child(_current_scene_ref)
	
	var scene_name = _SCENE_NAMES[p_index]
	_current_scene_ref = _SCENES[scene_name].instantiate()
	
	add_child(_current_scene_ref)
