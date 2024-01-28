<img src='resonate-logo.png' width='128'>

# Resonate

An all-in-one sound and music management addon for the Godot game engine.

[![Static Badge](https://img.shields.io/badge/Godot-Asset_Library-red?style=for-the-badge&logo=godotengine&logoColor=white&color=%23558bbe)](https://godotengine.org/asset-library/asset)
[![Discord](https://img.shields.io/discord/796535676136718356?style=for-the-badge&logo=discord&logoColor=white&label=Discord&color=%235865F2)](https://hugemenace.co/discord)

## Supporting this project
This addon is free for personal & commercial use (under the [MIT license](LICENSE)). However, if you'd like to support this project financially, consider becoming a HugeMenace Patreon or "purchasing" (making a donation) this addon from Gumroad, where you can pay what you want.

[![Static Badge](https://img.shields.io/badge/Patreon-Support_this_project-red?style=for-the-badge&logo=patreon&logoColor=white&color=%23f3621d)](https://www.patreon.com/hugemenace)
[![Static Badge](https://img.shields.io/badge/Gumroad-Support_this_project-pink?style=for-the-badge&logo=gumroad&logoColor=white&color=%23f795e8)
](https://hugemenace.gumroad.com/l/resonate-godot-addon)

## Features
- Pooled audio stream players.
- Automatic 2D and 3D space detection.
- Polyphonic playback.
- Stemmed music tracks.
- Music crossfading.

## Overview

Resonate has two core systems: the SoundManager and the MusicManager. Both of these systems are enabled by using Sound and Music banks present throughout your scene(s).

The SoundManager automatically pools and orchestrates AudioStream players for you and gives you control over the players when needed. 

The MusicManager composes music tracks built from stems and supports the (cross)fading of tracks or stems out of the box.

Resonate is the solution when you need more than just the basics but don't need more sophisticated or complicated audio systems such as FMOD or Wwise.

## Docs

- You can view a full breakdown, API reference, and walkthrough of the [SoundManager documentation here](docs/sound-manager.md).
- You can view a full breakdown, API reference, and walkthrough of the [MusicManager documentation here.](docs/music-manager.md)

## Examples

This repo is a Godot project you can clone and run locally. Inside of the `examples/` folder is a scene demonstrating the various features of the Sound and Music managers.

## Getting the addon

- You can download this addon from within the Godot editor by searching for it on the Asset Library. 
- You can grab the latest version from the Github releases page.
- You can also clone/download this repo and extract the `resonate` directory out of the `addons` folder.
- You can grab the addon from Gumroad.

## License

This project is provided free for personal and commercial use under the [MIT license.](LICENSE)