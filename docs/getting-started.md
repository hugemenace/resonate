# Getting started

Godot provides a simple and functional audio engine with all the raw ingredients. However, it leaves it up to you to decide how to organise, manage and orchestrate audio in your projects.

**Resonate** is an *audio manager* designed to fill this gap, providing both convenient and flexible ways to implement audio more easily in Godot. 

## Installation

Once you have downloaded Resonate into your project `addons/` directory, open **Project > Project Settings** and go to the **Plugins** tab. Click on the **Enable** checkbox to enable the plugin.

Resonate has two core systems: the **SoundManager** and the **MusicManager** which are available as global singletons (Autoload). You can confirm if these are available and enabled under **Project > Project Settings > Autoload**.

The `SoundManager` and `MusicManager` will now be available from any GDScript file. However, Resonate needs to initialise and load properly, so you should be aware of the script execution order.

## Script execution order

Resonate needs to initialise `PooledAudioStreamPlayers` and search the node tree for every `SoundEventResource` available within `SoundBank` and `MusicBank` nodes during its own `_ready()` function.

To immediately trigger sounds or music upon the launch of your runtime, you need to subscribe to the relevant `loaded` signal. The following concepts apply to both the `SoundManager` and `MusicManager`:

```GDScript
func _ready() -> void:
	MusicManager.loaded.connect(on_music_manager_loaded)
	
func on_music_manager_loaded() -> void:
	MusicManager.play("boss_fight")
```

You can also perform a safety check to ensure `MusicManager.loaded` is true before a function call.
