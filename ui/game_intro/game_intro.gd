extends Control

@export var game_panels_array: Array[Texture2D]
@onready var default_panels: Sprite2D = $DefaultPanels
@onready var animated_panel: AnimatedSprite2D = $AnimatedPanel
@onready var dialogue_ui: DialogueUI = $DialogueUI
@export var GAME_INTRO_NPC: NpcStats
var dialogue_index = 0
var start_dialogue: bool = false
var change_scene_indexes = [3, 9, 10, 13, 15, 17, 0]
const GAME = preload("res://scenes/game/game.tscn")


func _ready() -> void:
	PlayerData.is_talking = true
	dialogue_ui.dialogues = GAME_INTRO_NPC.dialogues
	dialogue_ui.npc_name.text = GAME_INTRO_NPC.name
	dialogue_ui.npc_sprites.hide()
	dialogue_ui.npc_name.hide()
	dialogue_ui.text_finished.connect(_on_text_finished)
	animated_panel.play("default")
	

# FORGIVE ME FATHER FOR THE HARDCODED MESS I AM ABOUT TO MAKE
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if start_dialogue == false:
			dialogue_ui.show()
			start_dialogue = true
			PlayerData.is_talking = true
			return
		
		if change_scene_indexes[0] == dialogue_index:
			dialogue_ui.hide()
			start_dialogue = false
			PlayerData.is_talking = false
			
			if dialogue_index in [3, 9, 10]:
				dialogue_ui.player_sprites.hide()
				dialogue_ui.player_name.hide()
			else:
				dialogue_ui.player_sprites.show()
				dialogue_ui.player_name.show()
			
			change_scene_indexes.pop_front()
			default_panels.texture = game_panels_array.pop_front()
			
		
		if dialogue_index == 12:
			dialogue_ui.npc_name.show()
		else:
			dialogue_ui.npc_name.hide()
		
		if dialogue_index == 27:
			PlayerData.is_talking = false
			get_tree().change_scene_to_packed(GAME)
		

func _on_text_finished() -> void:
	dialogue_index += 1
