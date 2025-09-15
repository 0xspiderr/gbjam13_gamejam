class_name DialogueBox
extends Control


@onready var text_animation_player: AnimationPlayer = %TextAnimationPlayer
@onready var dialogue_label: Label = %DialogueLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func draw_text(text: String) -> void:
	dialogue_label.text = ""
	
	# draw text letter by letter
	dialogue_label.text = text
	text_animation_player.play(&"character")
