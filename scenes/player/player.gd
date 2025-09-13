class_name Player
extends CharacterBody2D


@export var speed: float = 100.0
@export var friction: float = 4.5
@export var acceleration: float = 12.5
@onready var player_sprites: AnimatedSprite2D = $PlayerSprites


var player_dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	# dont process player character move input if in combat.
	if PlayerData.is_in_combat:
		return
	
	_move_player(delta)
	_play_animation()
	move_and_slide()


func _move_player(delta: float) -> void:
	player_dir = Input.get_vector("left", "right", "up", "down")
	# velocity weight determines wether the player will accelerate or slow down based on input
	var velocity_weight := 0.0
	# normalize direction so that the player speed will be the same diagonally too.
	player_dir = player_dir.normalized()
	
	if player_dir:
		velocity_weight = delta * acceleration
	else:
		velocity_weight = delta * friction
	
	velocity.x = lerpf(velocity.x, player_dir.x * speed, velocity_weight)
	velocity.y = lerpf(velocity.y, player_dir.y * speed, velocity_weight)


func _play_animation() -> void:
	var player_dir_len: float = player_dir.length()
	
	if player_dir_len == 0:
		player_sprites.play(&"idle")
	elif player_dir.y > 0:
		player_sprites.play(&"walk_down")
	elif player_dir.y < 0:
		player_sprites.play(&"walk_up")
	elif player_dir.x > 0:
		player_sprites.play(&"walk_right")
	elif player_dir.x < 0:
		player_sprites.play(&"walk_left")
	else:
		player_sprites.play(&"idle")
		player_sprites.stop()
