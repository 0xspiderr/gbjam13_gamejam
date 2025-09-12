extends Control


@onready var draw_card_btn: Button = %DrawCardBtn
@onready var roll_dice_btn: Button = %RollDiceBtn

@export var tween_scale_up: Vector2 = Vector2(1.25, 1.25)
@export var tween_scale_down: Vector2 = Vector2(1.0, 1.0)

func _ready() -> void:
	draw_card_btn.disabled = false
	draw_card_btn.visible = true
	roll_dice_btn.disabled = true
	roll_dice_btn.visible = false


#region BUTTON LOGIC
func _on_test_btn_pressed() -> void:
	EventBus.end_combat.emit()


func _on_draw_card_btn_pressed() -> void:
	_tween_btn_scale(draw_card_btn)


func _on_roll_dice_btn_pressed() -> void:
	_tween_btn_scale(roll_dice_btn)


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
	tween.tween_property(button, "scale", tween_scale_up, 0.2)
	tween.tween_property(button, "scale", tween_scale_down, 0.2)


func _on_tween_finished() -> void:
	print("hi")
	_buttons_toggle()
#endregion
