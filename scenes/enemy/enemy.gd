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
@export var stats: EnemyStats
@export var _player: Player = null


@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite
@onready var patrol_timer: Timer = $PatrolTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var area_detection_component: AreaDetectionComponent = $AreaDetectionComponent
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


var _current_state: State = State.PATROL
var _max_health: int = 0
var _current_health: int = 0
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
	_max_health = stats.max_health
	_current_health = _max_health
	
	# animations
	enemy_sprite.sprite_frames = stats.sprite_frames
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
	_navigate(stats.speed)


func _on_patrol_timer_timeout() -> void:
	var nav_rid: RID = navigation_agent_2d.get_navigation_map()
	var random_pos = NavigationServer2D.map_get_random_point(nav_rid, 1, false)
	
	navigation_agent_2d.target_position = random_pos
	_change_state(State.PATROL)
	wait_timer.start()


func _change_state(new_state: State) -> void:
	_current_state = new_state


func _on_chase_player_area_body_entered(body: Node2D) -> void:
	if body is Player:
		patrol_timer.stop()
		wait_timer.stop()
		_change_state(State.CHASE)


func _on_chase_player_area_body_exited(body: Node2D) -> void:
	if body is Player:
		patrol_timer.start()


func _do_state_action() -> void:
	match _current_state:
		State.PATROL:
			_patrol()
		State.CHASE:
			_chase_player()
		_:
			pass


func _chase_player() -> void:
	print(stats.chase_speed)
	_navigate(stats.chase_speed)


func _navigate(speed: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
	
	var next_path_pos = navigation_agent_2d.get_next_path_position()
	var dir = global_position.direction_to(next_path_pos).normalized()
	
	var animation_dir = round(dir)
	if abs(animation_dir.x) > abs(animation_dir.y):
		_enemy_dir = Vector2(animation_dir.x, 0)
	else:
		_enemy_dir = Vector2(0, animation_dir.y) 
	
	velocity = dir * speed


func _on_wait_timer_timeout() -> void:
	_change_state(State.WAIT)
	velocity = Vector2.ZERO
	_enemy_dir = Vector2.ZERO
	patrol_timer.start()


func _on_path_update_timer_timeout() -> void:
	if _current_state == State.CHASE:
		navigation_agent_2d.target_position = _player.global_position
