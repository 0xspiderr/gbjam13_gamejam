class_name NPC
extends CharacterBody2D


@export var npc_stats: NpcStats
@onready var npc_sprite: AnimatedSprite2D = $NpcSprite


func _ready() -> void:
	npc_sprite.sprite_frames = npc_stats.sprite_frames
	npc_sprite.animation = &"idle"
	npc_sprite.play(&"idle")
