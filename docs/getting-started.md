# Getting started

Godot provides a simple and functional audio engine with all the raw ingredients. However, it leaves it up to you to decide how to organise, manage and orchestrate audio in your projects.

**Resonate** is an *audio manager* designed to fill this gap, providing both convenient and flexible ways to implement audio more easily in Godot. 

## Installation

Once you have downloaded Resonate into your project `addons/` directory, open **Project > Project Settings** and go to the **Plugins** tab. Click on the **Enable** checkbox to enable the plugin.

It's good practice to reload your project to ensure freshly installed plugins work correctly. Go to **Project > Reload Current Project**.

Resonate has two core systems: the **SoundManager** and the **MusicManager** which are available as global singletons (Autoload). You can confirm if these are available and enabled under **Project > Project Settings > Autoload**.

The `SoundManager` and `MusicManager` will now be available from any GDScript file. However, Resonate needs to initialise and load properly, so you should be aware of the [script execution order](#script-execution-order).

## Concepts

The following concepts explain how the various components of Resonate work together.

**Sound** (one-shots, sound effects, dialogue) is managed differently compared to **Music.** This is why Resonate comprises of two core systems: the `SoundManager` and `MusicManager`.

### Sound

A **SoundEvent** is any sound that can be triggered, controlled and stopped from code. Anything in your game that produces a sound will need an equivalent SoundEvent. Instead of playing an AudioStream directly, you trigger events in response to gameplay and Resonate takes care of the rest. Events are made up of one or more AudioStreams which are treated as variations to be played at random when the event is triggered, e.g. triggering a "footsteps" event plays one of several pre-recorded variations to add variety and realism to your sound design. You can add as many variations to an event as you need. Using an event name means you have a consistent reference used to trigger sounds, but can easily update the AudioStream files associated with each event independently.

A **SoundBank** is a collection of SoundEvents. As your project grows, SoundBanks help you organise related sound events such as "dialogue" or "impacts" sound effects into groups. You can have as many SoundBanks as you want or need to keep your project organised in a way that suits your game's architecture. Banks also act a little bit like a namespace, e.g. creating separate "player" and "npc" SoundBanks allows you to trigger a "death" dialogue sound event from either bank without name collisions.

### Music

A **MusicTrack** is a piece of music comprised of one or more **Stems**. By default, tracks will fade in/out when played or stopped, and this fade time can be configured. If you play a MusicTrack when another is already playing, the two tracks will be cross-faded so that the new track takes over.

Layers of a MusicTrack are called **Stems**, which typically represent different instruments or mix busses, e.g. "drums", "bass", "melody". This allows for stems to be enabled and disabled independently. By default, stems fade in/out and this fade time can be configured. Care should be taken to ensure Stems are set to loop (see import settings) and that they are either all of the same length or a measure division that enables them to loop in sync with each other. Stems can be used like layers in order to create a dynamic and changing composition. In the context of sound design for games this is sometimes referred to as *vertical composition*. As an example, you could enable a "drums" stem in response to an increase in gameplay tension, then disable it when the tension dissipates.

A **MusicBank** is a collection of MusicTracks. As your project grows, MusicBanks help you organise related music tracks into groups. You can have as many MusicBanks as you want or need to keep your project organised in a way that suits your game's architecture. Banks also act a little bit like a namespace, e.g. creating separate MusicBanks for distinct levels or areas in your game world allows you to name and trigger an "ambient" or "combat" music track from either bank without name collisions. This can help you standardise how you integrate with other game systems, or simply organise audio with a consistent labelling schema.

## Script execution order

Resonate needs to initialise `PooledAudioStreamPlayers` and search the entire scene/node tree for every `SoundBank` and `MusicBank`. This process requires at least one game tick to complete.

Therefore, to immediately trigger sounds or music upon your game's launch, you need to subscribe to the relevant `loaded` signal. The following concepts apply to both the `SoundManager` and `MusicManager`:

```GDScript
func _ready() -> void:
	MusicManager.loaded.connect(on_music_manager_loaded)
	
func on_music_manager_loaded() -> void:
	MusicManager.play("boss_fight")
```

You can also perform a safety check to ensure `MusicManager.has_loaded` is true before a function call.

## Scene changes & runtime node creation

Resonate will scan the scene tree for all music and sound banks when your game launches, which it uses internally to create lookup tables. It will also automatically update those tables whenever a node is inserted or removed from the scene tree. If you load a script at runtime attempting to use either the MusicManager or SoundManager, you can leverage the `updated` signal to ensure you're ready to play music or trigger sound events without issues:

```GDScript
var _instance_jump: PooledAudioStreamPlayer = SoundManager.null_instance()

func _ready():
	SoundManager.updated.connect(on_sound_manager_updated)

func _input(p_event: InputEvent) -> void:
	if p_event.is_action_pressed("jump"):
		_instance_jump.trigger()

func on_sound_manager_updated() -> void:
	if SoundManager.should_skip_instancing(_instance_jump):
		return
	
	_instance_jump = SoundManager.instance("player", "jump")

	SoundManager.release_on_exit(self, _instance_jump)
```

## Digging deeper

To understand the music or sound managers in more detail, view examples of setting up banks, or inspect their corresponding APIs, check out the dedicated [MusicManager](music-manager.md) or [SoundManager](sound-manager.md) documentation.
