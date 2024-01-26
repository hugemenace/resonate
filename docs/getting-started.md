# Getting started

Resonate is split into two primary systems: the **SoundManager** and **MusicManager**. Both managers rely on banks (a collection of sound events or music tracks). These banks can be included anywhere in your scene hierarchy and will be auto-loaded by each manager when the game starts.

## SoundManager

The sound manager is responsible for playing (triggering) sound events defined by each SoundBank in your game. Each SoundBank has a label, bus, mode, and a collection of events.

![SoundBanks](https://private-user-images.githubusercontent.com/77056966/299886754-d25e25ea-44d2-4ff5-a1ae-c65a450d8c54.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYyNDcyMzAsIm5iZiI6MTcwNjI0NjkzMCwicGF0aCI6Ii83NzA1Njk2Ni8yOTk4ODY3NTQtZDI1ZTI1ZWEtNDRkMi00ZmY1LWExYWUtYzY1YTQ1MGQ4YzU0LnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDAxMjYlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMTI2VDA1Mjg1MFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTYyYzhmNDMwYWU1YTZmNDFhNWUzY2FmZGE3Y2M2MzEyMzNlZjJmZDU3NTI4ODM3Njc2ZTg5NjZhZmQ2NDBhYTEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.iUrZvK3zb9-er8CQNN96LuWT4UCxSelo8LPPE2oYxU0)

Every event is a type of SoundEventResource with a name, bus, and collection of streams. Whenever the sound manager is instructed to trigger an event, one of its corresponding streams will be played randomly. This behaviour allows you to create variations for events, such as footsteps, so they do not sound overly repetitive when played. You can, of course, only supply one stream, which will then always be played as it's the only one available.

The SoundManager automatically creates and pools the necessary stream players. A pool is created for each space type: 1D, 2D, and 3D. The size of these pools can be configured in your project settings under Audio/Manager/Sound.

Triggering an event comes in 3 forms: simple (one-shot), played at a position, or played (attached) on a specific node. The last two options will automatically detect whether the sound should come from the 2D or 3D pool based on the position (Vector2/Vector3) or node type (Node2D/Node3D) you provide to it.

Furthermore, the triggering of an event can be done automatically or manually. If triggered automatically, the SoundManager will reserve one stream player from the appropriate pool and instruct it to play your event. Once playback finishes, the stream player will be returned to the pool. When triggered manually, the SoundManager will reserve one of the stream players and give you exclusive access to it, on which you can trigger the event as many times as you wish. Once you've finished triggering the event, you must manually release it back to the pool (or continue using it indefinitely).

For a complete walkthrough on setting up SoundBanks and triggering events, see the [SoundManager documentation](sound/sound-manager.md).

## MusicManager

The MusicManager plays music (tracks) defined by each MusicBank in your game. Each MusicBank has a mode and a collection of tracks.

![SoundBanks](https://private-user-images.githubusercontent.com/77056966/299886750-a48c7986-ed8f-49cf-a717-5a03ccf03881.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYyNDcyMzAsIm5iZiI6MTcwNjI0NjkzMCwicGF0aCI6Ii83NzA1Njk2Ni8yOTk4ODY3NTAtYTQ4Yzc5ODYtZWQ4Zi00OWNmLWE3MTctNWEwM2NjZjAzODgxLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDAxMjYlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMTI2VDA1Mjg1MFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTA3MDBmNmUwYTc5M2Y4ZDMwYmE5YWEzZmRhOGI3NjJhMWM3MzZlZDIzOTY5YTNmNWJjMDMzMmYyMWU3YzAxNzgmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.5DcXnWsSftbEWqJvgUHfJPd0PtFVOSoiCgyJawAGzdM)

Every track is a type of MusicResource with a name and a collection of stems. Each stem has a label, a toggle on whether it is enabled, and an audio stream. The purpose behind stems in music tracks is to allow more diverse and exciting (dynamic) tracks. For example, you may play a track that, by default, only plays a pad and melody stem. Then, when an enemy is nearby, a drum stem can be enabled to heighten the tension or suspense. Of course, if you don't wish to split your music into stems, you can associate the entire audio track with a single stem and have it enabled by default.

The MusicManager will only play one track at a time. Starting a new track will automatically crossfade with the currently playing track. How quickly tracks will crossfade is configurable. Enabling or disabling stems will also fade them by a configurable amount of time.

For a complete walkthrough on setting up MusicBanks and playing tracks, see the [MusicManager documentation](music/music-manager.md).
