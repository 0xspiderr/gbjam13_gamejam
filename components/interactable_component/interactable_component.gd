class_name InteractableComponent
extends StaticBody2D


@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@export var interactable_stats: InteractableStats
@onready var area_shape: CollisionShape2D = %AreaShape
@onready var collision_shape: CollisionShape2D = %CollisionShape
var scene_to_change: PackedScene = null
const LEVEL_0: PackedScene = preload("res://scenes/levels/level0.tscn")
@onready var dialogue_box: DialogueBox = $DialogueBox


func _ready() -> void:
	# when a new interactable spawns get the first animation from it's resource
	# which is the idle animation for every npc and play it.
	scene_to_change = interactable_stats.scene_to_change
	var idle_anim = interactable_stats.sprite_frames.get_animation_names()[0]
	animated_sprite.sprite_frames = interactable_stats.sprite_frames
	animated_sprite.animation = idle_anim
	animated_sprite.play(idle_anim)
	_set_shapes()


func _on_interactable_component_area_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.entered_interactable_area.emit(scene_to_change, self)


func _set_shapes() -> void:
	# change the area size based on the spawned object
	var new_area_shape = RectangleShape2D.new()
	new_area_shape.size = interactable_stats.area_size
	area_shape.shape = new_area_shape
	var new_col_shape = RectangleShape2D.new()
	new_col_shape.size = interactable_stats.collision_size
	collision_shape.shape = new_col_shape


func _on_interactable_component_area_body_exited(body: Node2D) -> void:
	if PlayerData.keys_obtained >= interactable_stats.needs_keys:
		if body is Player:
			EventBus.exited_interactable_area.emit()
