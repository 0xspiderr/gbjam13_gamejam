extends Control

@export var game_panels_array: Array[Texture2D]
@onready var default_panels: Sprite2D = $DefaultPanels
@onready var animated_panel: AnimatedSprite2D = $AnimatedPanel
@onready var dialogue_ui: DialogueUI = $DialogueUI
@export var GAME_INTRO_NPC: NpcStats
var dialogue_index = 0
var start_dialogue: bool = false
var change_scene_indexes = [2, 7, 0]
var stop_talking_indexes = [1, 6, 0]

func _ready() -> void:
	PlayerData.is_talking = true
	dialogue_ui.dialogues = GAME_INTRO_NPC.dialogues
	dialogue_ui.npc_sprites.hide()
	dialogue_ui.npc_name.hide()
	animated_panel.play("default")
	

# FORGIVE ME FATHER FOR THE HARDCODED MESS I AM ABOUT TO MAKE
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if start_dialogue == false:
			dialogue_ui.show()
			start_dialogue = true
			return
		
		if dialogue_index == stop_talking_indexes[0]:
			PlayerData.is_talking = false
			stop_talking_indexes.pop_front()
		
		if dialogue_index == change_scene_indexes[0]:
			if dialogue_index == 2:
				dialogue_ui.player_sprites.hide()
				dialogue_ui.player_name.hide()
			else:
				dialogue_ui.player_sprites.show()
				dialogue_ui.player_name.show()
			start_dialogue = false
			default_panels.texture = game_panels_array.pop_front()
			animated_panel.stop()
			animated_panel.hide()
			dialogue_ui.hide()
			PlayerData.is_talking = true
			change_scene_indexes.pop_front()
		
		if start_dialogue == true:
			dialogue_index += 1
