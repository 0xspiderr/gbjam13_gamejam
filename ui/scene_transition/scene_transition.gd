class_name SceneTransition
extends CanvasLayer


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func play_transitions():
	show()
	await get_tree().create_timer(0.5).timeout
	animation_player.play("dissolve_out")
	await animation_player.animation_finished
	hide()
