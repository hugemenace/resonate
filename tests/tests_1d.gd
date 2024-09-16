extends Node2D


var _utils: ResonateTestUtils


func _ready():
	_utils = ResonateTestUtils.create(self)
	
	SoundManager.loaded.connect(on_sound_manager_loaded)


func test_simple_playback() -> void:
	print("[*] test_simple_playback")
	
	SoundManager.play("tests", "note")
	
	await _utils.end_test()
	

func test_simple_varied_playback() -> void:
	print("[*] test_simple_varied_playback")
	
	var pool_size = ProjectSettings.get_setting(
			ResonatePlugin.POOL_1D_SIZE_SETTING_NAME, 
			ResonatePlugin.POOL_1D_SIZE_SETTING_DEFAULT)
	
	for i in (pool_size - 1):
		SoundManager.play_varied("tests", "note", randf_range(0.5, 1.5), randf_range(-20.0, 0.0))
		await _utils.sleep(randf_range(0.025, 0.05))
	
	await _utils.end_test()
	

func test_instance_triggering() -> void:
	print("[*] test_instance_triggering")
	
	var instance = SoundManager.instance("tests", "note") as PooledAudioStreamPlayer
	instance.trigger()
	
	await _utils.end_test()
	

func test_instance_triggering_pool_exhaustion() -> void:
	print("[*] test_instance_triggering_pool_exhaustion")
	
	var pool_size = ProjectSettings.get_setting(
			ResonatePlugin.POOL_1D_SIZE_SETTING_NAME, 
			ResonatePlugin.POOL_1D_SIZE_SETTING_DEFAULT)
			
	var instances = []
	for i in (pool_size - 1):
		var instance = SoundManager.instance("tests", "note") as PooledAudioStreamPlayer
		instance.trigger()
		instances.append(instance)
		
		await _utils.sleep(0.1)
	
	push_warning("---- v ---- you should see a warning about pool exhaustion here ---- v ----")
	
	var overflow_instance = SoundManager.instance("tests", "note") as PooledAudioStreamPlayer
	overflow_instance.trigger()
	
	push_warning("---- ^ ---- you should see a warning about pool exhaustion here ---- ^ ----")
	
	for instance in instances:
		instance.release()
	
	await _utils.end_test()
	
	print("[*] should not warn about pool exhaustion here")
	
	SoundManager.play("tests", "note")
	
	await _utils.end_test()
	

func test_polyphonic_instance_triggering() -> void:
	print("[*] test_polyphonic_instance_triggering")
	
	var instance = SoundManager.instance_poly("tests", "note") as PooledAudioStreamPlayer
	
	var max_polyphony = ProjectSettings.get_setting(
			ResonatePlugin.MAX_POLYPHONY_SETTING_NAME, 
			ResonatePlugin.MAX_POLYPHONY_SETTING_DEFAULT)
			
	for i in (max_polyphony * 2):
		instance.trigger()
		await _utils.sleep(randf_range(0.025, 0.05))
	
	await _utils.end_test()


func test_null_instancing() -> void:
	print("[*] test_null_instancing")
	
	var instance_1d = SoundManager.null_instance()
	if not instance_1d is NullPooledAudioStreamPlayer:
		push_error("[!] instance_1d is not a NullPooledAudioStreamPlayer")
	
	var instance_2d = SoundManager.null_instance_2d()
	if not instance_2d is NullPooledAudioStreamPlayer2D:
		push_error("[!] instance_2d is not a NullPooledAudioStreamPlayer2D")
		
	var instance_3d = SoundManager.null_instance_3d()
	if not instance_3d is NullPooledAudioStreamPlayer3D:
		push_error("[!] instance_3d is not a NullPooledAudioStreamPlayer3D")
		
	await _utils.end_test()


func test_should_skip_instancing() -> void:
	print("[*] test_should_skip_instancing")
	
	var instance = SoundManager.null_instance()
	
	if SoundManager.should_skip_instancing(instance):
		push_error("[!] attempted to skip instancing a Null instance")
	
	instance = SoundManager.instance("tests", "note") as PooledAudioStreamPlayer
	
	if not SoundManager.should_skip_instancing(instance):
		push_error("[!] attempted to skip instancing a real instance")
		
	instance.release()
		
	await _utils.end_test()
	

func on_sound_manager_loaded() -> void:
	await test_simple_playback()
	await test_simple_varied_playback()
	await test_instance_triggering()
	await test_instance_triggering_pool_exhaustion()
	await test_polyphonic_instance_triggering()
	await test_null_instancing()
	await test_should_skip_instancing()
	
	_utils.quit()
