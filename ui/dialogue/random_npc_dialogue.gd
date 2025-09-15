extends Control


var wait_time: float = 1.0
var visibility_time: float = 1.0
@onready var rand_dialogue_timer: Timer = $RandDialogueTimer
@onready var dialogue_visibility_timer: Timer = $DialogueVisibilityTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	randomize()
	visible = false
	wait_time = randf_range(1.0, 10.0)
	rand_dialogue_timer.wait_time = wait_time
	rand_dialogue_timer.start()


func _on_rand_dialogue_timer_timeout() -> void:
	visible = true
	animation_player.play(&"character")
	wait_time = randf_range(5.0, 15.0)
	visibility_time = randf_range(3.0, 5.0)
	rand_dialogue_timer.wait_time = wait_time
	dialogue_visibility_timer.wait_time = visibility_time
	rand_dialogue_timer.start()
	dialogue_visibility_timer.start()


func _on_dialogue_visibility_timer_timeout() -> void:
	visible = false
