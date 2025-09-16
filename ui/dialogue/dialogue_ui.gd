class_name DialogueUI
extends Control


@onready var dialogue_box: DialogueBox = %DialogueBox
var dialogue_list: Array[String] = []
var diag_index: int = 0
var dialogue_line_finished: bool = true


func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void: 
	if dialogue_list.is_empty():
		rewind_data()
		return
	
	if event.is_action_pressed("interact") and dialogue_line_finished:
		dialogue_line_finished = false
		continue_dialogue()


func continue_dialogue() -> void:
	if diag_index >= dialogue_list.size():
		rewind_data()
		return
	
	dialogue_box.draw_text(dialogue_list[diag_index])
	await dialogue_box.text_animation_player.animation_finished
	diag_index += 1
	dialogue_line_finished = true


func rewind_data() -> void:
	diag_index = 0
	dialogue_list = []
	dialogue_line_finished = true
	PlayerData.is_talking = false
	visible = false
