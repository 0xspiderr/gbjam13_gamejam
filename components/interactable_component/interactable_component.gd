extends Area2D


@onready var interactable_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var interactable_stats: InteractableStats


func _ready() -> void:
	# when a new interactable spawns get the first animation from it's resource
	# which is the idle animation for every npc and play it.
	var idle_anim = interactable_stats.sprite_frames.get_animation_names()[0]
	interactable_sprite.sprite_frames = interactable_stats.sprite_frames
	interactable_sprite.animation = idle_anim
	interactable_sprite.play(idle_anim)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("player entered interactable area")
