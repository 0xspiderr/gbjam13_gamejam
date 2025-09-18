class_name DialogueUI
extends Control

@onready var panel: Panel = $Panel
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var player_sprites: AnimatedSprite2D = $PlayerSprites
@onready var npc_sprites: AnimatedSprite2D = $NpcSprites

@onready var player_initial_pos: Vector2 = player_sprites.position
@onready var npc_initial_pos: Vector2 = npc_sprites.position
var previous_speaker: String = ""

var dialogues: Array[Dialogue] = []
var dialogue_line_finished: bool = true
var tween_pos: int = 8
var tween_scale: Vector2 = Vector2(1.15, 1.15)


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
		
		var dialogue: Dialogue = dialogues.front()
		on_speaker_changed(dialogue.speaker)
		change_sprite_on_emotion(dialogue.speaker, dialogue.emotion)
		continue_dialogue(dialogue.line)


func continue_dialogue(dialogue: String) -> void:
	dialogue_box.draw_text(dialogue)
	await dialogue_box.text_animation_player.animation_finished
	dialogue_line_finished = true
	dialogues.pop_front()


func on_speaker_changed(speaker: String) -> void:
	if previous_speaker != speaker:
		previous_speaker = speaker
		# this flips the panel when the speaker changes in the dialogue
		panel.scale.x *= -1.0
		tween_sprite_pos()

	


func tween_sprite_pos() -> void:
	var player_tween = create_tween()
	var npc_tween = create_tween()
	
	# tween parameters
	var player_x = player_sprites.position.x
	var player_y = player_sprites.position.y
	var npc_x = npc_sprites.position.x
	var npc_y = npc_sprites.position.y
	var npc_scale = Vector2(1.1, 1.1)
	var player_scale = Vector2(1.1, 1.1)
	
	
	if previous_speaker == "player":
		player_y -= tween_pos
		npc_y += tween_pos
		player_scale = tween_scale
		npc_scale = Vector2.ONE
	elif previous_speaker == "npc":
		player_y += tween_pos
		npc_y -= tween_pos
		player_scale = Vector2.ONE
		npc_scale = tween_scale
		
	
	player_tween.tween_property(player_sprites, "position", Vector2(player_x, player_y), 0.40)
	player_tween.tween_property(player_sprites, "scale", player_scale, 0.3)
	npc_tween.tween_property(npc_sprites, "position", Vector2(npc_x, npc_y), 0.40)
	npc_tween.tween_property(npc_sprites, "scale", npc_scale, 0.3)


func change_sprite_on_emotion(speaker: String, emotion: String) -> void:
	if is_player_speaking(speaker):
		player_sprites.animation = emotion
	else:
		npc_sprites.animation = emotion


func is_player_speaking(speaker: String) -> bool:
	return true if speaker == "player" else false


func rewind_data() -> void:
	dialogues.clear()
	dialogue_line_finished = true
	
	player_sprites.scale = Vector2.ONE
	npc_sprites.scale = Vector2.ONE
	player_sprites.position = player_initial_pos
	npc_sprites.position = npc_initial_pos
	previous_speaker = ""
	
	
	PlayerData.is_talking = false
	visible = false
