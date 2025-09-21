extends Control

@export var dialogue_array: Array[String]
@onready var outro_text:DialogueBox = $CenterContainer/DialogueBox
var dialogues_size = 0
var dialogue_index = 0

const CREDITS = preload("uid://cood1lhiileoh")

func _ready() -> void:
	dialogues_size = dialogue_array.size()
  

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if dialogue_index<dialogues_size:
			var text = dialogue_array[dialogue_index]
			dialogue_index +=1
			outro_text.draw_text(text)
			await outro_text.text_animation_player.animation_finished 
		else:
			get_tree().change_scene_to_packed(CREDITS)
