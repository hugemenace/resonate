# MusicManager

## Introduction

The **MusicManager** is responsible for playing music tracks. It does so through a **StemmedMusicStreamPlayer** (SMSP), which extends Godot's **AudioStreamPlayer**. The core feature of SMSPs, as the name suggests, is the management and playback of ***stems***.

![MusicManager](images/music-manager.png)

Stems are music tracks split horizontally. For example, a music track may be split into pad, melody, and drum stems. Each of these stems can be played in isolation or in-sync with any or all of the other stems. This feature (while not required) allows you to craft more dynamic in-game music. For example, while the player is far enough away from a boss, only the pad stem plays. Then when the player gets closer, the melody stem gets added in. Finally, when the player is within the boss's detection distance, the drum stem gets added in. This helps you form a music track that grows in intensity without having to swap music tracks in and out entirely. It's a more organic and seamless transition.

### MusicBanks

The way you configure music is through the use of **MusicBanks**. Each MusicBank contains one or more music tracks, each of which contains one or more stems. Each stem contains one audio stream.

![MusicBanks](images/music-banks.png)

**MusicBanks** are automatically discovered by the **MusicManager** when your game starts, and can be located anywhere in your active scene(s).

### Fading & crossfading

Whenever you start or stop either an entire music track or a single stem, you can provide a (cross)fade time. If you want either of those to start immediately, just provide a (cross)fade time of zero seconds.

## Usage

### Creating MusicBanks

#### Step 1

Add a new MusicBank node to your scene.

![MusicBankNode](images/add-music-bank-node.jpg)

#### Step 2

Give your new MusicBank a label and then create a new MusicTrackResource. A MusicTrackResource represents one track in your music bank. Each track requires a name, which you will use to start it from your script(s).

![AddMusicResource](images/add-music-resource.gif)

#### Step 3

Create as many MusicStemResources as you track requires. Each stem requires a name, which you will use to enable or disable it from your script(s). If you mark a stem as enabled at the resource level, it will automatically be started for you when you play the music track. If often makes sense to have you core stem enabled by default.

![AddMusicStemResource](images/add-music-stem-resources.gif)

### Playing music

To start a new music track, just call the `play` method on the MusicManager with the name of the bank and track you want to play.

```GDScript
MusicManager.play("combat", "boss_fight")
```

To enable or disable stems on the currently playing track, just call `enabled_stem` or `disable_stem`.

```GDScript
MusicManager.enable_stem("melody")
MusicManager.disable_stem("drums")
```
