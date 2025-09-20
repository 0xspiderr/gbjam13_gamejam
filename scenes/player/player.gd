class_name Player
extends CharacterBody2D


@export var speed: float = 100.0
@export var combat_player_sprites: SpriteFrames
@export var casino_player_sprites: SpriteFrames
@onready var player_sprites: AnimatedSprite2D = $PlayerSprites
@onready var _void: Sprite2D = $Void

var player_dir: Vector2 = Vector2.ZERO
var last_position: Vector2


#region BUILT IN GODOT METHODS
func _ready() -> void:
	var level = get_parent().get_parent()
	if level.name == "Level0":
		player_sprites.sprite_frames = casino_player_sprites
	else:
		player_sprites.sprite_frames = combat_player_sprites
		_void.show()
		


func _physics_process(_delta: float) -> void:
	# dont process player character move input if in combat or if talking
	# to an npc.
	if PlayerData.is_in_combat or PlayerData.is_talking:
		player_sprites.play(&"idle")
		return
	
	_play_animation()
	_move_player()
	move_and_slide()
#endregion


#region MOVEMENT AND ANIMATION LOGIC
func _move_player() -> void:
	player_dir = Input.get_vector("left", "right", "up", "down")
	
	if player_dir == Vector2(1, 0) or player_dir == Vector2(-1, 0):
		velocity.x = player_dir.x * speed
		last_position = position
		velocity.y = 0
	if player_dir == Vector2(0, 1) or player_dir == Vector2(0, -1):
		velocity.y = player_dir.y * speed
		velocity.x = 0
		last_position = position
	if player_dir not in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0),Vector2(-1, 0)]:
		velocity = Vector2.ZERO
		last_position = position
	


func _play_animation() -> void:
	if last_position == position:
		player_sprites.play(&"idle")
		return
	
	var player_dir_len: float = player_dir.length()
	
	if player_dir_len == 0:
		player_sprites.play(&"idle")
	elif player_dir.y == 1:
		player_sprites.play(&"walk_down")
	elif player_dir.y == -1:
		player_sprites.play(&"walk_up")
	elif player_dir.x == 1:
		player_sprites.play(&"walk_right")
	elif player_dir.x == -1:
		player_sprites.play(&"walk_left")
#endregion
