class_name ResonateTestUtils
extends Node


var _base: Node


static func create(p_base: Node) -> ResonateTestUtils:
	var utils = new()
	utils._base = p_base
	return utils


func sleep(p_time: float) -> void:
	await _base.get_tree().create_timer(p_time).timeout


func end_test() -> void:
	await sleep(0.1)


func quit() -> void:
	_base.get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	_base.get_tree().quit()
