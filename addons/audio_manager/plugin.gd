@tool
class_name AudioManagerPlugin
extends EditorPlugin


static var SOUND_BANK_SETTING_NAME = "audio/manager/sound/bank"
static var SOUND_BANK_SETTING_DEFAULT = "Sound"

static var POOL_1D_SIZE_SETTING_NAME = "audio/manager/sound/pool_1D_size"
static var POOL_1D_SIZE_SETTING_DEFAULT = 1

static var POOL_2D_SIZE_SETTING_NAME = "audio/manager/sound/pool_2D_size"
static var POOL_2D_SIZE_SETTING_DEFAULT = 1

static var POOL_3D_SIZE_SETTING_NAME = "audio/manager/sound/pool_3D_size"
static var POOL_3D_SIZE_SETTING_DEFAULT = 1

static var MAX_POLYPHONY_SETTING_NAME = "audio/manager/sound/max_polyphony"
static var MAX_POLYPHONY_SETTING_DEFAULT = 8

static var MUSIC_BANK_SETTING_NAME = "audio/manager/music/bank"
static var MUSIC_BANK_SETTING_DEFAULT = "Music"


func _enter_tree():
	add_autoload_singleton("SoundManager", "sound_manager/sound_manager.gd")
	add_autoload_singleton("MusicManager", "music_manager/music_manager.gd")
	add_custom_type("SoundBank", "Node", preload("sound_manager/sound_bank.gd"), preload("sound_manager/sound_bank.png"))
	add_custom_type("MusicBank", "Node", preload("music_manager/music_bank.gd"), preload("music_manager/music_bank.png"))
	
	add_project_setting(
		SOUND_BANK_SETTING_NAME,
		SOUND_BANK_SETTING_DEFAULT,
		TYPE_STRING)
		
	add_project_setting(
		POOL_1D_SIZE_SETTING_NAME,
		POOL_1D_SIZE_SETTING_DEFAULT,
		TYPE_INT, PROPERTY_HINT_RANGE, "1,128")
		
	add_project_setting(
		POOL_2D_SIZE_SETTING_NAME,
		POOL_2D_SIZE_SETTING_DEFAULT,
		TYPE_INT, PROPERTY_HINT_RANGE, "1,128")
		
	add_project_setting(
		POOL_3D_SIZE_SETTING_NAME,
		POOL_3D_SIZE_SETTING_DEFAULT,
		TYPE_INT, PROPERTY_HINT_RANGE, "1,128")
		
	add_project_setting(
		MAX_POLYPHONY_SETTING_NAME,
		MAX_POLYPHONY_SETTING_DEFAULT,
		TYPE_INT, PROPERTY_HINT_RANGE, "1,128")
		
	add_project_setting(
		MUSIC_BANK_SETTING_NAME,
		MUSIC_BANK_SETTING_DEFAULT,
		TYPE_STRING)


func _exit_tree():
	remove_autoload_singleton("SoundManager")
	remove_autoload_singleton("MusicManager")
	remove_custom_type("SoundBank")
	remove_custom_type("MusicBank")


func add_project_setting(p_name: String, p_default, p_type: int, p_hint: int = PROPERTY_HINT_NONE, p_hint_string: String = ""):
	if ProjectSettings.has_setting(p_name): 
		return

	ProjectSettings.set_setting(p_name, p_default)
	
	ProjectSettings.add_property_info({
		"name": p_name,
		"type": p_type,
		"hint": p_hint,
		"hint_string": p_hint_string,
	})
	
	ProjectSettings.set_initial_value(p_name, p_default)
	
	var error: int = ProjectSettings.save()
	
	if error: 
		push_error("AudioManager - Encountered error %d when saving project settings." % error)
