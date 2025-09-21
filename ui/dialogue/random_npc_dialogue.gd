class_name RandomNPCDialogue
extends Node2D

enum
{
	ANGRY = 0,
	NORMAL = 1,
}
var rand_index: int = 0
var visibility_time: float = 1.0
@onready var rand_dialogue_timer: Timer = $RandDialogueTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var animated_speaking: AnimatedSprite2D = $AnimatedSpeaking
var is_wife: bool = false


func _ready() -> void:
	hide()
	randomize()
	rand_dialogue_timer.wait_time = randf_range(5.0, 10.0)
	rand_dialogue_timer.start()


func _on_rand_dialogue_timer_timeout() -> void:
	show()
	animated_speaking.show()
	animated_sprite.show()
	_play_animation()
	rand_index = randi_range(0, 2)
	rand_dialogue_timer.wait_time = randf_range(5.0, 10.0)
	rand_dialogue_timer.start()


func _play_animation() -> void:
	match rand_index:
		ANGRY:
			if is_wife:
				animated_sprite.play(&"angry_combat")
			else:
				animated_sprite.play(&"angry")
		NORMAL:
			if is_wife:
				animated_sprite.play(&"normal_combat")
			else:
				animated_sprite.play(&"normal")
		_:
			if is_wife:
				animated_sprite.play(&"normal_combat")
			else:
				animated_sprite.play(&"normal")
				
	if is_wife:
		animated_speaking.play(&"speak_combat")
	else:
		animated_speaking.play(&"speak")


func _on_animated_speaking_animation_finished() -> void:
	animated_speaking.stop()
	animated_speaking.hide()


func _on_animated_sprite_animation_finished() -> void:
	animated_sprite.hide()
