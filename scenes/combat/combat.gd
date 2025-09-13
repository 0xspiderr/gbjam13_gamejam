extends Control


enum
{
	DRAW_CARD = 0,
	ROLL_DICE = 1
}
@onready var draw_card_btn: Button = %DrawCardBtn
@onready var roll_dice_btn: Button = %RollDiceBtn
@onready var button_container: PanelContainer = %ButtonContainer
@onready var combat_indicator_label: Label = %CombatIndicatorLabel
@onready var card: ColorRect = %Card
@onready var card_value_label: Label = %CardValueLabel
@onready var text_animation_player: AnimationPlayer = $MarginContainer/VBoxContainer/HBoxContainer4/HBoxContainer3/TextAnimationPlayer

@export var tween_scale_up: Vector2 = Vector2(1.0, 1.0)
@export var tween_scale_down: Vector2 = Vector2(0.9, 0.9)
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


#region TWEENS
func _tween_btn_scale(button: Button) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", tween_scale_down, 0.2)
	tween.tween_property(button, "scale", tween_scale_up, 0.2)
#endregion


#region COMBAT LOGIC
func _button_action() -> void:
	match current_button:
		DRAW_CARD:
			_draw_card()
		ROLL_DICE:
			_roll_dice()


func _draw_card() -> void:
	SoundManager.play_sfx(SoundManager.FLIP_CARD, false)
	combat_indicator_label.text = ""
	card_value_label.text = ""
	
	var player_card_value: int = randi_range(1, 13)
	var enemy_card_value: int = randi_range(1, 13)
	
	if player_card_value > enemy_card_value:
		_button_toggle()
	
	_draw_text("You drew %s\nenemy drew %s" % [player_card_value, enemy_card_value], combat_indicator_label)


func _roll_dice() -> void:
	combat_indicator_label.text = ""
	var first_player_dice_value: int = randi_range(1, 6)
	var second_player_dice_value: int = randi_range(1, 6)
	
	_button_toggle()
	_draw_text("You rolled %s & %s" % [first_player_dice_value, second_player_dice_value], combat_indicator_label)

#endregion


func _draw_text(text: String, label: Label) -> void:
	# draw text letter by letter
	#SoundManager.play_sfx(SoundManager.DIALOGUE_1, true)
	label.text = text
	text_animation_player.play(&"character")
	await text_animation_player.animation_finished
	#SoundManager.stop_sfx()
