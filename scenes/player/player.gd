class_name Player
extends CharacterBody2D


@export var _speed: float = 50.0
@export var _friction: float = 4.5
@export var _acceleration: float = 12.5

func _physics_process(delta: float) -> void:
	_move_player(delta)
	move_and_slide()


func _move_player(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var velocity_weight := 0.0
	# normalize direction so that the player speed will be the same diagonally too.
	direction = direction.normalized()
	
	if direction:
		velocity_weight = delta * _acceleration
	else:
		velocity_weight = delta * _friction

	velocity.x = lerpf(velocity.x, direction.x * _speed, velocity_weight)
	velocity.y = lerpf(velocity.y, direction.y * _speed, velocity_weight)
