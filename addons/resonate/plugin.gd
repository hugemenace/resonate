@tool
class_name ResonatePlugin
extends EditorPlugin


static var SOUND_BANK_SETTING_NAME = "audio/manager/sound/bank"
static var SOUND_BANK_SETTING_DEFAULT = ""
static var SOUND_BANK_SETTING_ACTUAL = "Sound"

static var POOL_1D_SIZE_SETTING_NAME = "audio/manager/sound/pool_1D_size"
static var POOL_1D_SIZE_SETTING_DEFAULT = 1
static var POOL_1D_SIZE_SETTING_ACTUAL = 16

static var POOL_2D_SIZE_SETTING_NAME = "audio/manager/sound/pool_2D_size"
static var POOL_2D_SIZE_SETTING_DEFAULT = 1
static var POOL_2D_SIZE_SETTING_ACTUAL = 16

static var POOL_3D_SIZE_SETTING_NAME = "audio/manager/sound/pool_3D_size"
static var POOL_3D_SIZE_SETTING_DEFAULT = 1
static var POOL_3D_SIZE_SETTING_ACTUAL = 16

static var MAX_POLYPHONY_SETTING_NAME = "audio/manager/sound/max_polyphony"
static var MAX_POLYPHONY_SETTING_DEFAULT = 8
static var MAX_POLYPHONY_SETTING_ACTUAL = 32

static var MUSIC_BANK_SETTING_NAME = "audio/manager/music/bank"
static var MUSIC_BANK_SETTING_DEFAULT = ""
static var MUSIC_BANK_SETTING_ACTUAL = "Music"


func _enter_tree():
	add_autoload_singleton("SoundManager", "sound_manager/sound_manager.gd")
	add_autoload_singleton("MusicManager", "music_manager/music_manager.gd")
	add_custom_type("SoundBank", "Node", preload("sound_manager/sound_bank.gd"), preload("sound_manager/sound_bank.svg"))
	add_custom_type("MusicBank", "Node", preload("music_manager/music_bank.gd"), preload("music_manager/music_bank.svg"))
	
	add_project_setting(
		SOUND_BANK_SETTING_NAME,
		SOUND_BANK_SETTING_DEFAULT,
		SOUND_BANK_SETTING_ACTUAL,
		TYPE_STRING)
		
	add_project_setting(
		POOL_1D_SIZE_SETTING_NAME,
		POOL_1D_SIZE_SETTING_DEFAULT,
		POOL_1D_SIZE_SETTING_ACTUAL,
		TYPE_INT, PROPERTY_HINT_RANGE, "1,128")
		
	add_project_setting(
		POOL_2D_SIZE_SETTING_NAME,
		POOL_2D_SIZE_SETTING_DEFAULT,
		POOL_2D_SIZE_SETTING_ACTUAL,
		TYPE_INT, PROPERTY_HINT_RANGE, "1,128")
		
	add_project_setting(
		POOL_3D_SIZE_SETTING_NAME,
		POOL_3D_SIZE_SETTING_DEFAULT,
		POOL_3D_SIZE_SETTING_ACTUAL,
		TYPE_INT, PROPERTY_HINT_RANGE, "1,128")
		
	add_project_setting(
		MAX_POLYPHONY_SETTING_NAME,
		MAX_POLYPHONY_SETTING_DEFAULT,
		MAX_POLYPHONY_SETTING_ACTUAL,
		TYPE_INT, PROPERTY_HINT_RANGE, "1,128")
		
	add_project_setting(
		MUSIC_BANK_SETTING_NAME,
		MUSIC_BANK_SETTING_DEFAULT,
		MUSIC_BANK_SETTING_ACTUAL,
		TYPE_STRING)


func _exit_tree():
	remove_autoload_singleton("SoundManager")
	remove_autoload_singleton("MusicManager")
	remove_custom_type("SoundBank")
	remove_custom_type("MusicBank")


func add_project_setting(p_name: String, p_default, p_actual, p_type: int, p_hint: int = PROPERTY_HINT_NONE, p_hint_string: String = ""):
	if ProjectSettings.has_setting(p_name): 
		return

	ProjectSettings.set_setting(p_name, p_actual)
	
	ProjectSettings.add_property_info({
		"name": p_name,
		"type": p_type,
		"hint": p_hint,
		"hint_string": p_hint_string,
	})
	
	ProjectSettings.set_initial_value(p_name, p_default)
	
	var error: int = ProjectSettings.save()
	
	if error: 
		push_error("Resonate - Encountered error %d when saving project settings." % error)
