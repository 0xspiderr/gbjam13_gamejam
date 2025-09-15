class_name DialogueBox
extends Control


@onready var text_animation_player: AnimationPlayer = %TextAnimationPlayer
@onready var dialogue_label: Label = %DialogueLabel


func draw_text(text: String) -> void:
	dialogue_label.text = ""
	
	# draw text letter by letter
	SoundManager.play_sfx(SoundManager.DIALOGUE_2, true)
	dialogue_label.text = text
	text_animation_player.play(&"character")
	await text_animation_player.animation_finished
	SoundManager.stop_sfx()
