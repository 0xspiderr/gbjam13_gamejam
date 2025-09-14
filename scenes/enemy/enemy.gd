class_name Enemy
extends CharacterBody2D


# use resources for enemies, that way this enemy script
# will spawn enemies based on the level we are in
@export var enemy_stats: EnemyStats
@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var patrol_timer: Timer = $PatrolTimer
@onready var area_detection_component: AreaDetectionComponent = $AreaDetectionComponent


var _speed: int = 0
var _max_health: int = 0
var _current_health: int = 0
var _directions: Array[Vector2] = [Vector2(1, 0), Vector2(-1, 0), \
Vector2(0, 1), Vector2(0, -1)]
var _enemy_dir: Vector2 = Vector2.ZERO
var _is_colliding: bool = false


func _ready() -> void:
	_enemy_stats_setup()


func _physics_process(delta: float) -> void:
	# dont process enemy movement if player is talking or in combat
	if PlayerData.is_in_combat or PlayerData.is_talking:
		enemy_sprite.play(&"idle")
		return
	
	velocity = _enemy_dir * _speed
	_play_animation()
	move_and_slide()


func _enemy_stats_setup() -> void:
	# attributes
	_max_health = enemy_stats.max_health
	_current_health = _max_health
	_speed = enemy_stats.speed
	
	# animations
	enemy_sprite.sprite_frames = enemy_stats.sprite_frames
	enemy_sprite.play(&"idle")


func _play_animation() -> void:
	if _is_colliding:
		enemy_sprite.play(&"idle")
		return
	
	var enemy_dir_len: float = _enemy_dir.length()
	
	if enemy_dir_len == 0:
		enemy_sprite.play(&"idle")
	elif _enemy_dir.y == 1:
		enemy_sprite.play(&"walk_down")
	elif _enemy_dir.y == -1:
		enemy_sprite.play(&"walk_up")
	elif _enemy_dir.x == 1:
		enemy_sprite.play(&"walk_right")
	elif _enemy_dir.x == -1:
		enemy_sprite.play(&"walk_left")


func _patrol() -> void:
	randomize()
	var index = randi_range(0, 3)
	_enemy_dir = _directions[index]


func _on_patrol_timer_timeout() -> void:
	_patrol()
