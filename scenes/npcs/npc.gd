class_name NPC
extends CharacterBody2D


@export var npc_stats: NpcStats
@onready var npc_sprite: AnimatedSprite2D = $NpcSprite
var idle_anim: String


func _ready() -> void:
	# when a new npc spawns get the first animation from it's resource
	# which is the idle animation for every npc and play it.
	idle_anim = npc_stats.sprite_frames.get_animation_names()[0]
	npc_sprite.sprite_frames = npc_stats.sprite_frames
	npc_sprite.animation = idle_anim
	npc_sprite.play(idle_anim)


func _physics_process(_delta: float) -> void:
	# dont process movement logic for the npcs if the player is in combat
	if PlayerData.is_in_combat or PlayerData.is_talking:
		return


func _on_dialogue_area_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.entered_dialogue_area.emit(self)


func _on_dialogue_area_body_exited(body: Node2D) -> void:
	if body is Player:
		EventBus.exited_dialogue_area.emit()
