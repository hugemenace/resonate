# SoundManager

## Introduction

The **SoundManager** is responsible for triggering sounds. It does so through **PooledAudioStreamPlayers** (PASPs), which extend Godot's native **AudioStreamPlayers** (ASPs). PASPs, like ASPs, support audio playback in 1D, 2D, and 3D space, making them useful for any game sound effect.

![SoundManager](../images/sound-manager.png)

Sound events can be configured with multiple variations (audio streams) such that a variation is chosen at random when they are played. This is extremely useful when requiring organic-sounding events such as footsteps, gunshots, collisions, etc.

### SoundBanks

The way you configure sound events and their variations is through the use of **SoundBanks**. Each SoundBank you create has a name and several associated events, among other configuration options.

![SoundManager](../images/sound-banks.png)

**SoundBanks** are automatically discovered and loaded by the **SoundManager** when your game starts. This allows you to co-locate your **SoundBanks** with the entities or systems they belong to.

All registered sound events can be triggered in three ways: uniformly, at a fixed position, or attached to a node. Uniformly triggered sound events always play in 1D space and, therefore, will be heard as if coming from all directions (no stereo or 3D panning). Sound events triggered at a fixed position (Vector2/Vector3) or attached to a node (Node2D/Node3D) will automatically be positioned in 2D or 3D space. They will be heard accordingly through the use of panning.

When you trigger a sound event, the **SoundManager** will retrieve a free PASP from one of its appropriate 1D, 2D, or 3D pools. After the event, the PASP will be freed and returned to the pool, available for the next event. Using pools means you do not have to insert ASPs into your scenes manually. For performance reasons, however, the **SoundManager** will limit how many PASPs it creates in each pool. This limit can be configured under `Audio/Manager/Sound` in your project settings.

When you want to play a particular event consistently, you can request exclusive use of a PASP from the **SoundManager**. When doing so, it will not be automatically returned to its pool when an event has finished playing. It can be manually released if you wish to return it to its pool.

### Polyphony

By default, every PASP, when told to trigger an event, will play the event once. If instructed to trigger the event again while a previous variation is still playing, it will stop playback and immediately begin playing a new random variation. Polyphonic playback can be enabled in situations where this is undesirable, for instance, playing rapid gunshots. When told to trigger, polyphonic playback will start playing a random variation concurrently with all other variations already playing. The maximum number of concurrent variations a PASP can play can be configured under `Audio/Manager/Sound` in your project settings.

## Usage

### Creating SoundBanks

### Triggering events

## API

### Functions

#### Play

Will immediately trigger the event in 1D space when called.

`play(p_bank_label: String, p_event_name: String, p_bus: String = "") -> void`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |


#### Play at position

Will immediately trigger the event in 2D or 3D space when called.

`play_at_position(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> void`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_position` | **Required** | The position you want to play this event from (supports `Vector2` and `Vector3` types.) |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |


#### Play on node

Will immediately trigger the event in 2D or 3D space when called.

`play_on_node(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> void`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_node` | **Required** | The node you want to attach (and trigger) this event on (supports `Node2D` and `Node3D` types or subtypes.) |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |

#### Instance

Will return a reserved `PooledAudioStreamPlayer` that you can trigger events from at any point.

`instance(p_bank_label: String, p_event_name: String, p_bus: String = "") -> Variant`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |

#### Instance at position

Will return a reserved `PooledAudioStreamPlayer2D` or `PooledAudioStreamPlayer3D` that you can trigger events from at any point.

`instance_at_position(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> Variant`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_position` | **Required** | The position you want to play this event from (supports `Vector2` and `Vector3` types.) |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |

#### Instance on node

Will return a reserved `PooledAudioStreamPlayer2D` or `PooledAudioStreamPlayer3D` that you can trigger events from at any point.

`instance_on_node(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> Variant`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_node` | **Required** | The node you want to attach (and trigger) this event on (supports `Node2D` and `Node3D` types or subtypes.) |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |

#### Instance polyphonic

Will return a reserved polyphonic `PooledAudioStreamPlayer` that you can trigger concurrent events from at any point.

`instance_poly(p_bank_label: String, p_event_name: String, p_bus: String = "") -> Variant`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |

#### Instance at position polyphonic

Will return a reserved polyphonic `PooledAudioStreamPlayer2D` or `PooledAudioStreamPlayer3D` that you can trigger concurrent events from at any point.

`instance_at_position_poly(p_bank_label: String, p_event_name: String, p_position, p_bus: String = "") -> Variant`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_position` | **Required** | The position you want to play this event from (supports `Vector2` and `Vector3` types.) |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |

#### Instance on node polyphonic

Will return a reserved polyphonic `PooledAudioStreamPlayer2D` or `PooledAudioStreamPlayer3D` that you can trigger concurrent events from at any point.

`instance_on_node_poly(p_bank_label: String, p_event_name: String, p_node, p_bus: String = "") -> Variant`

| Parameter | Type | Description |
| --- | --- | --- |
| `p_bank_label` | **Required** | The label of the bank you want to trigger an event from |
| `p_event_name` | **Required** | The name of the event to trigger |
| `p_node` | **Required** | The node you want to attach (and trigger) this event on (supports `Node2D` and `Node3D` types or subtypes.) |
| `p_bus` | Optional | The name of the audio bus you want this event to play through |

### Signals

#### Loaded

Emitted when the SoundManager has loaded and is ready to play sounds.

`signal loaded`

#### Pool Updated

Emitted every time one of the 1D, 2D, or 3D pools has been updated.

`signal pool_updated(p_type: pool_type, p_size: int)`

| Parameter | Description |
| --- | --- |
| `p_type` | One of the types included in the `PoolType` enum (`ONE_D`, `TWO_D`, `THREE_D`) |
| `p_size` | The updated size of the pool (how many players are free for use.) |