# Changelog

## [2.1.0](https://github.com/hugemenace/resonate/compare/v2.0.0...v2.1.0) (2024-01-31)


### Features

* add automatic detection of new sound and music banks during scene changes & runtime node insertion/deletion ([f964908](https://github.com/hugemenace/resonate/commit/f964908558b95adc18c0f3c92365f7eb37e664ae))
* enhance the is_playing method on the MusicManager to allow bank and track scoping ([90eb8d3](https://github.com/hugemenace/resonate/commit/90eb8d317203fc260f79a45e11ec07e4ff8fca98))

## [2.0.0](https://github.com/hugemenace/resonate/compare/v1.0.2...v2.0.0) (2024-01-30)


### ⚠ BREAKING CHANGES

* rename MusicResource to MusicTrackResource

### Features

* add a bus override option to MusicBanks and MusicTrackResources ([61ede7e](https://github.com/hugemenace/resonate/commit/61ede7ec1574f22fc84779427282b802a9523682))
* add global MusicManager and individual stem volume management ([02696cd](https://github.com/hugemenace/resonate/commit/02696cdade253a2d5374f73229f24624c59f0e0b))
* add labels to MusicBanks to allow the grouping/scoping of music tracks ([1192122](https://github.com/hugemenace/resonate/commit/1192122e5d5673184d3a820238154824cbe0c093))
* expose the MusicManager's loaded status via a has_loaded public variable ([4145ac0](https://github.com/hugemenace/resonate/commit/4145ac0cb7dc8b5767de0d9a9628c79991bf119c))


### Bug Fixes

* rename MusicResource to MusicTrackResource ([8ba7355](https://github.com/hugemenace/resonate/commit/8ba73556b28ef5b830e75c53d2b50c6dd9f3697e))
* update the build script to include a top-level name & version directory in the release .zip and also bundle-in a copy of the documentation ([8db1ae4](https://github.com/hugemenace/resonate/commit/8db1ae4fc04f11364cc556aff095dfe92a3e5431))

## [1.0.2](https://github.com/hugemenace/resonate/compare/v1.0.1...v1.0.2) (2024-01-29)


### Bug Fixes

* remove the extraneous pool_updated signal and PoolType enum from the SoundManager ([2066868](https://github.com/hugemenace/resonate/commit/2066868ff96f831d83624761addefd88af7e92b8))
* remove the SoundManager type references from the pooled audio stream players to avoid errors when the addon is disabled ([c3e3cd9](https://github.com/hugemenace/resonate/commit/c3e3cd91a3098d59eb2e24dd225a9e8121f94d02))

## [1.0.1](https://github.com/hugemenace/resonate/compare/v1.0.0...v1.0.1) (2024-01-28)


### Bug Fixes

* ensure the release zip includes the addons directory ([fc543d3](https://github.com/hugemenace/resonate/commit/fc543d33fde886c467fe071ee48e23371deda408))

## [1.0.0](https://github.com/hugemenace/resonate/compare/v0.1.0...v1.0.0) (2024-01-28)


### Features

* add a pool_updated event to the SoundManager ([0ada03c](https://github.com/hugemenace/resonate/commit/0ada03c4bb5805bcf9274210143cd060996626fc))
* add music track crossfading, stem toggle fading, and update the example music scene ([d3b180f](https://github.com/hugemenace/resonate/commit/d3b180fd08ee52144f4c496fbbb863e05c80d42f))
* add pool stats and tidy up the simple example scene ([03c7b4c](https://github.com/hugemenace/resonate/commit/03c7b4c174fc53e7e5fe77e6aebe189b6b301ae1))
* add process modes to music and sound banks ([d3f6142](https://github.com/hugemenace/resonate/commit/d3f61421f6d142c38c334b5add041ba63ad03403))
* add trigger_varied to pooled* audio streams to allow simplified pitch and volume control for reserved instances ([ee0bc2b](https://github.com/hugemenace/resonate/commit/ee0bc2b7337dda290ebadefcc79d317ee0dcd040))
* complete the 2D example scene ([a6a55fa](https://github.com/hugemenace/resonate/commit/a6a55fa04802d2c7f409fe3c6a3136b08ff00d04))
* complete the 3D example scene ([2a93dc7](https://github.com/hugemenace/resonate/commit/2a93dc7bcc94e5e06d98ab8f9857ff243176271c))
* complete the example music scene ([0e9fb4c](https://github.com/hugemenace/resonate/commit/0e9fb4c964307f54af5cf387f4141ce7d9b76d8a))
* complete the polyphonic example scene ([50cfcd2](https://github.com/hugemenace/resonate/commit/50cfcd2bf196d2a6c232a449cc615327c92b71a3))
* complete the simple example scene ([28a07c6](https://github.com/hugemenace/resonate/commit/28a07c68a50e42bc7415eaabe055f4d30149e6c0))


### Bug Fixes

* change the SoundManager's pool_type enum name to PoolType ([1705d10](https://github.com/hugemenace/resonate/commit/1705d10a03ebefb637802f3b3bfc47619db6e855))
* change the SoundManager's private _loaded member variable to a public has_loaded ([25477e3](https://github.com/hugemenace/resonate/commit/25477e3741f72e0036bdea641de70e987a624435))
* ensure that music is played through the bus configured in the project settings ([ed9b4c7](https://github.com/hugemenace/resonate/commit/ed9b4c7a9f64f3c64662aa045da445836d1fb9a2))
* fix the music example scene and add an is_playing function to the music manager ([9289a40](https://github.com/hugemenace/resonate/commit/9289a407c026dc638fb8dbbc9567d06e7f6db663))
* remove the reserved parameter from the pooled audio stream player's configure functions and ensure play* functions are set to auto-release when triggered ([822d6ee](https://github.com/hugemenace/resonate/commit/822d6eef439a8347c1dc4d82cc60f29632121ed0))


### Miscellaneous Chores

* release 1.0.0 ([c3945bc](https://github.com/hugemenace/resonate/commit/c3945bc7f93c124ca2a8900b71265deae813ae55))
