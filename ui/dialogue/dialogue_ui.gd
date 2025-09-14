class_name DialogueUI
extends Control


@onready var dialogue_box: DialogueBox = %DialogueBox
var dialogue_list: Array[String] = []
var diag_index: int = 0


func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if dialogue_list.is_empty():
		rewind_data()
		return
	
	if event.is_action_pressed("interact"):
		continue_dialogue()


func continue_dialogue() -> void:
	if diag_index >= dialogue_list.size():
		rewind_data()
		return
	
	dialogue_box.draw_text(dialogue_list[diag_index])
	diag_index += 1


func rewind_data() -> void:
	visible = false
	diag_index = 0
	PlayerData.is_talking = false
