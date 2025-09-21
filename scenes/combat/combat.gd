extends Control

signal player_death
signal enemy_death


enum
{
	DRAW_CARD = 0,
	ROLL_DICE = 1
}

enum
{
	ATTACK = 0,
	DEFENCE = 1
}

#region CONTROLS 
@onready var draw_card_btn: Button = %DrawCardBtn
@onready var roll_dice_btn: Button = %RollDiceBtn
@onready var button_container: CenterContainer = %ButtonContainer
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var combat_box: DialogueBox = %CombatBox
#endregion


#region DICE
@onready var animated_dice_1: AnimatedSprite2D = $AnimatedDice1
@onready var animated_dice_2: AnimatedSprite2D = $AnimatedDice2
@onready var dice_1_pos: Marker2D = $Dice1Pos
@onready var dice_2_pos: Marker2D = $Dice2Pos
@onready var dice_initial_pos: Marker2D = $DiceInitialPos
#endregion


#region CARD
@onready var card_1: Sprite2D = $Card1
@onready var card_2: Sprite2D = $Card2
const CARDS_RECOLORED: Texture2D = preload("uid://316gpc4pduya")
const CARD_BACK: Texture2D = preload("uid://blbmkjk61756w")
@onready var card_1_pos: Marker2D = $Card1Pos
@onready var card_2_pos: Marker2D = $Card2Pos
#endregion


#region SOUNDS
@onready var draw_card_sound: AudioStreamPlayer = $DrawCardSound
@onready var roll_dice_sound: AudioStreamPlayer = $RollDiceSound
#endregion

@export var _can_interact: bool = true

var buttons: Array[Button] = []
var current_button: int = 0
var round: int = 0
@onready var player_sprites: AnimatedSprite2D = %PlayerSprites

#region Player
@onready var player_health: ProgressBar = $PlayerPanel/PlayerHealth

#endregion

#region ENEMY
var enemy_stats: EnemyStats = null
var enemy_health: int
@onready var enemy_sprites: AnimatedSprite2D = %EnemySprites
@onready var enemy_label: Label = %EnemyLabel
@onready var enemy_health_bar: ProgressBar = %EnemyHealth

#endregion

func _ready() -> void:
	SoundManager.change_music_stream(SoundManager.COMBAT)
	enemy_health = enemy_stats.max_health
	enemy_health_bar.value = enemy_health
	player_health.value = PlayerData.current_health
	
	for button in button_container.get_children():
		buttons.append(button)
	
	buttons[current_button].visible = true
	buttons[current_button].disabled = false
	
	enemy_sprites.sprite_frames = enemy_stats.combat_sprite_frames
	enemy_label.text = enemy_stats.name
	enemy_sprites.play(&"idle")
	player_sprites.play(&"idle")


func _input(event: InputEvent) -> void:
	if not _can_interact:
		return
	if event.is_action_pressed("interact"):
		_can_interact = false
		_button_action()
		UIManager._tween_btn_scale(buttons[current_button])
		


#region BUTTON LOGIC
# JUST FOR TESTING 
func _on_test_btn_pressed() -> void:
	SoundManager.change_music_stream(SoundManager.OVERWORLD)
	EventBus.end_combat.emit()


func _button_toggle() -> void:
	buttons[current_button].visible = false
	buttons[current_button].disabled = true
	
	current_button = (current_button + 1) % buttons.size()
	buttons[current_button].visible = true
	buttons[current_button].disabled = false
#endregion


#region COMBAT LOGIC
func _button_action() -> void:
	match current_button:
		DRAW_CARD:
			_round_toggle()
			round = (round + 1) % 2
		ROLL_DICE:
			_roll_dice()

func _round_toggle() -> void:
	match round:
		ATTACK:
			_draw_card_attack()
		DEFENCE:
			_draw_card_defence()

func _draw_card_attack() -> void:
	_reset_card_pos()
	_reset_dice_pos()
	
	if PlayerData.current_health <= 0:
		player_death.emit()
	
	dialogue_box.draw_text("",10,false)
	await dialogue_box.text_animation_player.animation_finished
	combat_box.draw_text("ATTACK",10,false)
	await combat_box.text_animation_player.animation_finished
	SoundManager.randomize_pitch_scale(draw_card_sound)
	draw_card_sound.play()
	
	var player_card_value: int = randi_range(2, 13)
	var enemy_card_value: int = randi_range(2, 13)
	
	_draw_card_anim(player_card_value, enemy_card_value)
	if player_card_value > enemy_card_value:
		_button_toggle()
		
	var text := "You drew %s\nenemy drew %s" % [player_card_value, enemy_card_value]
	dialogue_box.draw_text(text,3)
	await dialogue_box.text_animation_player.animation_finished
	
	_can_interact = true

func _draw_card_defence() -> void:
	
	_reset_card_pos()
	_reset_dice_pos()
	if enemy_health <= 0:
		enemy_death.emit()
		
	dialogue_box.draw_text("",10,false)
	await dialogue_box.text_animation_player.animation_finished
	combat_box.draw_text("DEFENCE",10,false)
	await combat_box.text_animation_player.animation_finished
	
	SoundManager.randomize_pitch_scale(draw_card_sound)
	draw_card_sound.play()
	
	var player_card_value: int = randi_range(2, 13)
	var enemy_card_value: int = randi_range(2, 13)
	
	_draw_card_anim(player_card_value, enemy_card_value)
	if player_card_value < enemy_card_value:
		_enemy_deal_damage()
	
	var text := "You drew %s\nenemy drew %s" % [player_card_value, enemy_card_value]
	dialogue_box.draw_text(text,3)
	await dialogue_box.text_animation_player.animation_finished
	
	_can_interact = true

func _roll_dice() -> void:
	_reset_card_pos()
	SoundManager.randomize_pitch_scale(roll_dice_sound)
	roll_dice_sound.play()
	
	var first_player_dice_value: int = randi_range(1, 6)
	var second_player_dice_value: int = randi_range(1, 6)
	
	_play_dice_anim(first_player_dice_value, second_player_dice_value)
	_button_toggle()
	var text = "You rolled %s & %s" % [first_player_dice_value, second_player_dice_value]
	if first_player_dice_value == second_player_dice_value:
		text += " Critical hit!"
	dialogue_box.draw_text(text)
	await dialogue_box.text_animation_player.animation_finished
	var dice_mult = (first_player_dice_value + second_player_dice_value) / 4
	if first_player_dice_value == second_player_dice_value:
		_player_deal_damage(2 * dice_mult)
	else:
		_player_deal_damage(1 * dice_mult)
	_can_interact = true

func _player_deal_damage(mult) -> void:
	enemy_health -= (PlayerData.damage + PlayerData.extra_damage) * mult
	enemy_health_bar.value = enemy_health

func _enemy_deal_damage() -> void:
	PlayerData.current_health -= enemy_stats.damage
	player_health.value = PlayerData.current_health

#endregion

#region DICE ANIMATION LOGIC
func _play_dice_anim(value1: int, value2: int) -> void:
	animated_dice_1.show()
	animated_dice_2.show()
	
	var tween_dice1_pos = create_tween()
	var tween_dice2_pos = create_tween()
	var tween_dice1_scale = create_tween()
	var tween_dice2_scale = create_tween()
	animated_dice_1.play("roll")
	animated_dice_2.play("roll")
	tween_dice1_pos.tween_property(animated_dice_1, "position", dice_1_pos.position, 1)
	tween_dice1_scale.tween_property(animated_dice_1, "scale", Vector2(1, 1), 0.5)
	tween_dice2_pos.tween_property(animated_dice_2, "position", dice_2_pos.position, 1)
	tween_dice2_scale.tween_property(animated_dice_2, "scale", Vector2(1, 1), 0.5)
	await tween_dice1_pos.finished
	await tween_dice2_pos.finished
	animated_dice_1.stop()
	animated_dice_2.stop()
	animated_dice_1.animation = "value"
	animated_dice_2.animation = "value"
	
	animated_dice_1.frame = value1 - 1
	animated_dice_2.frame = value2 - 1


func _reset_dice_pos() -> void:
	var tween_dice1 = create_tween()
	var tween_dice2 = create_tween()
	tween_dice1.tween_property(animated_dice_1, "scale", Vector2(0, 0), 0.5)
	tween_dice2.tween_property(animated_dice_2, "scale", Vector2(0, 0), 0.5)
	
	await tween_dice1.finished
	await tween_dice2.finished
	animated_dice_1.hide()
	animated_dice_2.hide()
	animated_dice_1.position = dice_initial_pos.position
	animated_dice_2.position = dice_initial_pos.position
#endregion


#region DRAW CARD ANIMATION LOGIC
func _draw_card_anim(card_1_value: int, card_2_value: int) -> void:
	card_1.show()
	card_2.show()
	var tween_card_1_pos = create_tween()
	var tween_card_2_pos = create_tween()
	var tween_card_1_scale = create_tween()
	var tween_card_2_scale = create_tween()
	tween_card_1_pos.stop()
	tween_card_1_scale.stop()
	tween_card_2_pos.stop()
	tween_card_2_scale.stop()
	
	tween_card_1_pos.tween_property(card_1, "position", card_1_pos.position, 0.5)
	tween_card_2_pos.tween_property(card_2, "position", card_2_pos.position, 0.5)
	tween_card_1_pos.play()
	tween_card_2_pos.play()
	await tween_card_1_pos.finished
	await tween_card_2_pos.finished
	
	tween_card_1_scale.tween_property(card_1, "scale", Vector2(0, 0), 0.2)
	tween_card_2_scale.tween_property(card_2, "scale", Vector2(0, 0), 0.2)
	tween_card_1_scale.play()
	tween_card_2_scale.play()
	await tween_card_1_scale.finished
	await tween_card_2_scale.finished
	tween_card_1_scale.stop()
	tween_card_2_scale.stop()
	
	card_1.texture = CARDS_RECOLORED
	card_1.hframes = 13
	card_1.vframes = 4
	card_2.texture = CARDS_RECOLORED
	card_2.hframes = 13
	card_2.vframes = 4
	
	if card_1_value == 13:
		card_1.frame = 13
	else:
		card_1.frame = card_1_value - 1
	
	if card_2_value == 13:
		card_2.frame = 13
	else:
		card_2.frame = card_2_value - 1
	
	
	tween_card_1_scale.tween_property(card_1, "scale", Vector2.ONE, 0.2)
	tween_card_2_scale.tween_property(card_2, "scale", Vector2.ONE, 0.2)
	tween_card_1_scale.play()
	tween_card_2_scale.play()


func _reset_card_pos() -> void:
	card_1.hide()
	card_2.hide()
	card_1.position = Vector2.ZERO
	card_1.texture = CARD_BACK
	card_1.hframes = 1
	card_1.vframes = 1
	card_1.frame = 0
	card_2.position = Vector2.ZERO
	card_2.texture = CARD_BACK
	card_2.hframes = 1
	card_2.vframes = 1
	card_2.frame = 0
#endregion
