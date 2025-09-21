class_name DialogueBox
extends Control


@onready var text_animation_player: AnimationPlayer = %TextAnimationPlayer
@onready var dialogue_label: Label = %DialogueLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func draw_text(text: String, speed: float = 1, sound: bool = true) -> void:
	dialogue_label.text = ""
	text_animation_player.speed_scale = speed
	
	# draw text letter by letter
	dialogue_label.text = text
	text_animation_player.play(&"character")
	if sound:
		audio_stream_player.play()
