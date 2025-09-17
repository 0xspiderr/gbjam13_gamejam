class_name DialogueUI
extends Control


@onready var dialogue_box: DialogueBox = %DialogueBox
var dialogues: Array[Dialogue] = []
var npc_index: int = 0
var player_index: int = 0
var dialogue_line_finished: bool = true
var is_player_turn: bool = false


func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void: 
	if not PlayerData.is_talking:
		return
	
	if event.is_action_pressed("interact") and dialogue_line_finished:
		dialogue_line_finished = false
		if dialogues.is_empty():
			rewind_data()
			return
		var dialogue = dialogues.front()
		continue_dialogue(dialogue.line)


func continue_dialogue(dialogue: String) -> void:
	dialogue_box.draw_text(dialogue)
	await dialogue_box.text_animation_player.animation_finished
	dialogue_line_finished = true
	dialogues.pop_front()
	


func rewind_data() -> void:
	dialogues.clear()
	dialogue_line_finished = true
	is_player_turn = false
	PlayerData.is_talking = false
	visible = false
