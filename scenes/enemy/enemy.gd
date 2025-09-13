class_name Enemy
extends CharacterBody2D


# use resources for enemies, that way this enemy script
# will spawn enemies based on the level we are in
@export var enemy_stats: EnemyStats
@onready var enemy_sprite: Sprite2D = $EnemySprite
var max_health: int = 0
var current_health: int = 0


func _ready() -> void:
	_enemy_stats_setup()


func _enemy_stats_setup() -> void:
	max_health = enemy_stats.max_health
	current_health = max_health
	enemy_sprite.texture = enemy_stats.sprite
