extends Control


@onready var draw_card_btn: Button = %DrawCardBtn
@onready var roll_dice_btn: Button = %RollDiceBtn
@onready var button_container: PanelContainer = %ButtonContainer
@onready var combat_indicator_label: Label = %CombatIndicatorLabel
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var card: ColorRect = %Card
@onready var card_value_label: Label = %CardValueLabel

@export var tween_scale_up: Vector2 = Vector2(1.0, 1.0)
@export var tween_scale_down: Vector2 = Vector2(0.9, 0.9)
var _can_interact: bool = true


func _ready() -> void:
	SoundManager.change_music_stream(SoundManager.COMBAT)
	
	draw_card_btn.disabled = false
	draw_card_btn.visible = true
	roll_dice_btn.disabled = true
	roll_dice_btn.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if not _can_interact:
		return
	
	if event.is_action_pressed("interact"):
		_can_interact = false
		var buttons = button_container.get_children()
		for button in buttons:
			if not button.visible:
				continue
			
			if button.name == "DrawCardBtn":
				_draw_card()
			elif button.name == "RollDiceBtn":
				_roll_dice()
			
			_tween_btn_scale(button)
		cooldown_timer.start()


#region BUTTON LOGIC
# JUST FOR TESTING 
func _on_test_btn_pressed() -> void:
	SoundManager.change_music_stream(SoundManager.MAIN_MENU_OGG)
	EventBus.end_combat.emit()


func _buttons_toggle() -> void:
	draw_card_btn.disabled = !draw_card_btn.disabled
	draw_card_btn.visible = !draw_card_btn.visible
	roll_dice_btn.disabled = !roll_dice_btn.disabled
	roll_dice_btn.visible = !roll_dice_btn.disabled
#endregion


#region TWEENS
func _tween_btn_scale(button: Button) -> void:
	var tween: Tween = create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(button, "scale", tween_scale_down, 0.2)
	tween.tween_property(button, "scale", tween_scale_up, 0.2)


func _on_tween_finished() -> void:
	_buttons_toggle()
#endregion


#region COMBAT LOGIC
func _draw_card() -> void:
	combat_indicator_label.text = ""
	card_value_label.text = ""
	
	var card_value: int = randi_range(1, 11)
	card_value_label.text = str(card_value)
	_draw_text("You drew %s" % card_value, combat_indicator_label)


func _roll_dice() -> void:
	combat_indicator_label.text = ""
	var first_dice_value: int = randi_range(1, 6)
	var second_dice_value: int = randi_range(1, 6)
	_draw_text("You rolled %s & %s" % [first_dice_value, second_dice_value], combat_indicator_label)

#endregion


func _draw_text(text: String, label: Label) -> void:
	for char in text:
		await get_tree().create_timer(0.1).timeout
		label.text += char
	# wait for one second so the player can read the text
	await get_tree().create_timer(1.0).timeout
	_can_interact = true
