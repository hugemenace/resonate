<img src='reasonate-github-header.jpg' width='100%'>

# ***Resonate***

> [!WARNING]  
> **Resonate has been deprecated.** — No further development will occur. It's still compatible with Godot 4.0-4.2, but higher versions are untested. If you would like to take over its development, please reach out via our Discord server.

An all-in-one sound and music management addon for the Godot game engine (see compatibility).

[![Static Badge](https://img.shields.io/badge/Godot-Asset_Library-red?style=for-the-badge&logo=godotengine&logoColor=white&color=%23558bbe)](https://godotengine.org/asset-library/asset/2546)
[![Discord](https://img.shields.io/discord/796535676136718356?style=for-the-badge&logo=discord&logoColor=white&label=Discord&color=%235865F2)](https://hugemenace.co/discord)

## Features
- Pooled audio stream players.
- Automatic 2D and 3D space detection.
- Polyphonic playback.
- Stemmed music tracks.
- Music crossfading.

## TL;DR

Resonate has two core systems: the **SoundManager** and the **MusicManager**.

The **SoundManager** automatically pools and orchestrates **AudioStreamPlayers** for you and gives you control over the players when needed. 

The **MusicManager** composes music tracks built from ***stems*** and supports the (cross)fading of tracks or stems out of the box.

## Docs

- [Getting started](docs/getting-started.md)
- [SoundManager documentation](docs/sound-manager.md)
- [MusicManager documentation](docs/music-manager.md)

## Examples

This repo is a Godot project you can clone and run.

Inside the `examples/` folder are scenes demonstrating all the Sound and Music Manager's features.

## Getting the addon

You have a few different options:

- You can download Resonate from the [Godot Asset Library](https://godotengine.org/asset-library/asset/2546) (or from within the editor). 
- You can grab the latest version from the [Github releases page](https://github.com/hugemenace/resonate/releases).
- You can also clone or download this repo, and extract the `addons/resonate` directory into the root folder of your Godot project.
- You can grab the addon from [Gumroad](https://hugemenace.gumroad.com/l/resonate-godot-addon) (if you'd like to financially support this project).

## License

This project is provided ***free for personal and commercial use*** under the [MIT license](LICENSE) ❤
