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
@onready var card: ColorRect = %Card
@onready var card_value_label: Label = %CardValueLabel
@onready var dialogue_box: DialogueBox = %DialogueBox
#endregion

#region SOUNDS
@onready var draw_card_sound: AudioStreamPlayer = $DrawCardSound
@onready var roll_dice_sound: AudioStreamPlayer = $RollDiceSound
#endregion

@export var _can_interact: bool = true

var buttons: Array[Button] = []
var current_button: int = 0


func _ready() -> void:
	SoundManager.change_music_stream(SoundManager.COMBAT)
	
	for button in button_container.get_children():
		buttons.append(button)
	
	buttons[current_button].visible = true
	buttons[current_button].disabled = false


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
	SoundManager.randomize_pitch_scale(draw_card_sound)
	draw_card_sound.play()
	
	var player_card_value: int = randi_range(1, 13)
	var enemy_card_value: int = randi_range(1, 13)
	
	if player_card_value > enemy_card_value:
		_button_toggle()
	
	var text := "You drew %s\nenemy drew %s" % [player_card_value, enemy_card_value]
	dialogue_box.draw_text(text)
	await dialogue_box.text_animation_player.animation_finished
	_can_interact = true


func _roll_dice() -> void:
	SoundManager.randomize_pitch_scale(roll_dice_sound)
	roll_dice_sound.play()
	
	var first_player_dice_value: int = randi_range(1, 6)
	var second_player_dice_value: int = randi_range(1, 6)
	
	_button_toggle()
	var text = "You rolled %s & %s" % [first_player_dice_value, second_player_dice_value]
	dialogue_box.draw_text(text)
	await dialogue_box.text_animation_player.animation_finished
	_can_interact = true

#endregion
