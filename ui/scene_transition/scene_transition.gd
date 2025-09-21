class_name SceneTransition
extends CanvasLayer


@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect
var color_combat: Color = Color("2c0016")
var color_overworld: Color = Color("0f040f")


func set_rect_color(is_combat_scene: bool) -> void:
	if is_combat_scene:
		color_rect.color = color_combat
	else:
		color_rect.color = color_overworld


func play_transitions():
	show()
	await get_tree().create_timer(0.5).timeout
	animation_player.play("dissolve_out")
	await animation_player.animation_finished
	hide()
