class_name Enemy
extends CharacterBody2D


enum State
{
	WAIT = 0,
	PATROL = 1,
	CHASE = 2
}


# use resources for enemies, that way this enemy script
# will spawn enemies based on the level we are in
@export var enemy_stats: EnemyStats
@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var patrol_timer: Timer = $PatrolTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var area_detection_component: AreaDetectionComponent = $AreaDetectionComponent

@export var _player: Player = null
var current_state: State = State.PATROL
var _speed: int = 0
var _max_health: int = 0
var _current_health: int = 0
var _directions: Array[Vector2] = [Vector2(1, 0), Vector2(-1, 0), \
Vector2(0, 1), Vector2(0, -1)]
var _enemy_dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	_enemy_stats_setup()
	patrol_timer.start()


func _physics_process(_delta: float) -> void:
	# dont process enemy movement if player is talking or in combat
	if PlayerData.is_in_combat or PlayerData.is_talking:
		enemy_sprite.play(&"idle")
		return
	
	_do_state_action()
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
	velocity = _enemy_dir * _speed


func _on_patrol_timer_timeout() -> void:
	randomize()
	var index = randi_range(0, 3)
	_enemy_dir = _directions[index]
	_change_state(State.PATROL)
	wait_timer.start()


func _change_state(new_state: State) -> void:
	current_state = new_state


func _on_chase_player_area_body_entered(body: Node2D) -> void:
	if body is Player:
		patrol_timer.stop()
		_change_state(State.CHASE)


func _on_chase_player_area_body_exited(body: Node2D) -> void:
	if body is Player:
		patrol_timer.start()


func _do_state_action() -> void:
	match current_state:
		State.PATROL:
			_patrol()
		State.CHASE:
			_chase_player()
		_:
			pass


func _chase_player() -> void:
	var dir = round(position.direction_to(_player.position))

	if abs(dir.x) >= abs(dir.y):
		_enemy_dir = Vector2(dir.x, 0)
	else:
		_enemy_dir = Vector2(0, dir.y)
	
	velocity = _enemy_dir * (_speed + 25)

func _on_wait_timer_timeout() -> void:
	_change_state(State.WAIT)
	velocity = Vector2.ZERO
	_enemy_dir = Vector2.ZERO
	patrol_timer.start()
