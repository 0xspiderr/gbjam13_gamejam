class_name Player
extends CharacterBody2D


@export var speed: float = 50.0
@export var friction: float = 4.5
@export var acceleration: float = 12.5
@onready var player_sprites: AnimatedSprite2D = $PlayerSprites



var player_dir: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	_move_player(delta)
	_play_animation()
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()


func _move_player(delta: float) -> void:
	player_dir = Input.get_vector("left", "right", "up", "down")
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
	if player_dir.length() == 0:
		player_sprites.play(&"idle")
	else:
		player_sprites.stop()
