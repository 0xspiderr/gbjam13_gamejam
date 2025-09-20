class_name NpcStats
extends Resource

enum Options
{
	TALK = 0,
	SHOP = 1,
	EXIT = 2,
}

@export var name: String
@export var sprite_frames: SpriteFrames
@export var portraits: SpriteFrames
@export var dialogues: Array[Dialogue]
@export var dialogue_stream: AudioStream
@export var dialogue_options: Array[Options]
