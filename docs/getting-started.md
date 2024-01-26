# Getting started

Resonate is split into two primary systems: the **SoundManager** and **MusicManager**. Both managers rely on banks (a collection of sound events or music tracks). These banks can be included anywhere in your scene hierarchy and will be auto-loaded by each manager when the game starts.

## SoundManager

The sound manager is responsible for playing (triggering) sound events defined by each SoundBank in your game. Each SoundBank has a label, bus, mode, and a collection of events.

Every event is a type of SoundEventResource with a name, bus, and collection of streams. Whenever the sound manager is instructed to trigger an event, one of its corresponding streams will be played randomly. This behaviour allows you to create variations for events, such as footsteps, so they do not sound overly repetitive when played. You can, of course, only supply one stream, which will then always be played as it's the only one available.

The SoundManager automatically creates and pools the necessary stream players. A pool is created for each space type: 1D, 2D, and 3D. The size of these pools can be configured in your project settings under Audio/Manager/Sound.

Triggering an event comes in 3 forms: simple (one-shot), played at a position, or played (attached) on a specific node. The last two options will automatically detect whether the sound should come from the 2D or 3D pool based on the position (Vector2/Vector3) or node type (Node2D/Node3D) you provide to it.

Furthermore, the triggering of an event can be done automatically or manually. If triggered automatically, the SoundManager will reserve one stream player from the appropriate pool and instruct it to play your event. Once playback finishes, the stream player will be returned to the pool. When triggered manually, the SoundManager will reserve one of the stream players and give you exclusive access to it, on which you can trigger the event as many times as you wish. Once you've finished triggering the event, you must manually release it back to the pool (or continue using it indefinitely).

For a complete walkthrough on setting up SoundBanks and triggering events, see the [SoundManager documentation](sound/sound-manager.md).

## MusicManager

The MusicManager plays music (tracks) defined by each MusicBank in your game. Each MusicBank has a mode and a collection of tracks.

Every track is a type of MusicResource with a name and a collection of stems. Each stem has a label, a toggle on whether it is enabled, and an audio stream. The purpose behind stems in music tracks is to allow more diverse and exciting (dynamic) tracks. For example, you may play a track that, by default, only plays a pad and melody stem. Then, when an enemy is nearby, a drum stem can be enabled to heighten the tension or suspense. Of course, if you don't wish to split your music into stems, you can associate the entire audio track with a single stem and have it enabled by default.

The MusicManager will only play one track at a time. Starting a new track will automatically crossfade with the currently playing track. How quickly tracks will crossfade is configurable. Enabling or disabling stems will also fade them by a configurable amount of time.

For a complete walkthrough on setting up MusicBanks and playing tracks, see the [MusicManager documentation](music/music-manager.md).