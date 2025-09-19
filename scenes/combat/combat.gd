extends Control


enum
{
	DRAW_CARD = 0,
	ROLL_DICE = 1
}

#region CONTROLS 
@onready var draw_card_btn: Button = %DrawCardBtn
@onready var roll_dice_btn: Button = %RollDiceBtn
@onready var button_container: CenterContainer = %ButtonContainer
@onready var dialogue_box: DialogueBox = %DialogueBox
#endregion


#region DICE
@onready var animated_dice_1: AnimatedSprite2D = $AnimatedDice1
@onready var animated_dice_2: AnimatedSprite2D = $AnimatedDice2
@onready var dice_1_pos: Marker2D = $Dice1Pos
@onready var dice_2_pos: Marker2D = $Dice2Pos
@onready var dice_initial_pos: Marker2D = $DiceInitialPos
#endregion


#region CARD
@onready var card: Sprite2D = $Card
const CARDS_RECOLORED: Texture2D = preload("uid://316gpc4pduya")
@onready var card_1_pos: Marker2D = $Card1Pos

#endregion


#region SOUNDS
@onready var draw_card_sound: AudioStreamPlayer = $DrawCardSound
@onready var roll_dice_sound: AudioStreamPlayer = $RollDiceSound
#endregion

@export var _can_interact: bool = true

var buttons: Array[Button] = []
var current_button: int = 0
@onready var player_sprites: AnimatedSprite2D = %PlayerSprites

#region ENEMY
var enemy_stats: EnemyStats = null
@onready var enemy_sprites: AnimatedSprite2D = %EnemySprites
@onready var enemy_label: Label = %EnemyLabel
@onready var enemy_health: ProgressBar = %EnemyHealth

#endregion

func _ready() -> void:
	SoundManager.change_music_stream(SoundManager.COMBAT)
	
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
			_draw_card()
		ROLL_DICE:
			_roll_dice()

 
func _draw_card() -> void:
	_reset_dice_pos()
	SoundManager.randomize_pitch_scale(draw_card_sound)
	draw_card_sound.play()
	
	var player_card_value: int = randi_range(2, 13)
	var enemy_card_value: int = randi_range(2, 13)
	
	if player_card_value > enemy_card_value:
		_button_toggle()
	
	_draw_card_anim(player_card_value)
	var text := "You drew %s\nenemy drew %s" % [player_card_value, enemy_card_value]
	dialogue_box.draw_text(text)
	await dialogue_box.text_animation_player.animation_finished
	_can_interact = true


func _roll_dice() -> void:
	SoundManager.randomize_pitch_scale(roll_dice_sound)
	roll_dice_sound.play()
	
	var first_player_dice_value: int = randi_range(1, 6)
	var second_player_dice_value: int = randi_range(1, 6)
	
	_play_dice_anim(first_player_dice_value, second_player_dice_value)
	_button_toggle()
	var text = "You rolled %s & %s" % [first_player_dice_value, second_player_dice_value]
	dialogue_box.draw_text(text)
	await dialogue_box.text_animation_player.animation_finished
	_can_interact = true

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
func _draw_card_anim(value: int) -> void:
	card.show()
	var tween_card_pos1 = create_tween()
	
	tween_card_pos1.tween_property(card, "position", card_1_pos.position, 0.5)
	# tween_card.tween_property(card, "scale", Vector2(0, 0), 0.5)
	
	if value == 13:
		card.frame = 12
	else:
		card.frame = value - 1
#endregion
