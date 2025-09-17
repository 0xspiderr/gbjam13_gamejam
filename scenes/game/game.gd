class_name Game
extends Node


@onready var current_scene: Node = $CurrentScene
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var current_level: Node2D = null
var current_enemy: Enemy = null
var current_npc: NPC = null
var interactable_scene_change: PackedScene = null

const COMBAT_TSCN: PackedScene = preload("uid://cnseaei7cyk0j")
@onready var dialogue_ui: DialogueUI = %DialogueUI


#region BUILTIN METHODS
func _ready() -> void:
	SoundManager.change_music_stream(SoundManager.OVERWORLD)
	EventBus.start_combat.connect(_on_start_combat)
	EventBus.end_combat.connect(_on_end_combat)
	EventBus.entered_dialogue_area.connect(_on_entered_dialogue_area)
	EventBus.exited_dialogue_area.connect(_on_exited_dialogue_area)
	EventBus.entered_interactable_area.connect(_on_entered_interactable_area)
	EventBus.exited_interactable_area.connect(_on_exited_interactable_area)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()


func _input(event: InputEvent) -> void:
	# dont process player input if in combat or if talking
	# to an npc.
	if PlayerData.is_in_combat or PlayerData.is_talking:
		return
	
	if event.is_action_pressed("interact"):
		if PlayerData.can_interact:
			_change_level_scene(interactable_scene_change)
		
		if PlayerData.can_talk and is_instance_valid(current_npc):
			PlayerData.is_talking = true
			dialogue_ui.dialogues.assign(current_npc.npc_stats.dialogues)
			dialogue_ui.dialogue_box.audio_stream_player.stream = current_npc.npc_stats.dialogue_stream
			dialogue_ui.visible = true
#endregion


func _get_current_level() -> void:
	if current_scene.get_child_count():
		current_level = current_scene.get_child(0)


func _change_level_scene(scene: PackedScene) -> void:
	if current_scene.get_child_count():
		var instance := scene.instantiate()
		current_level = instance
		
		# temporary solution until combat is implemented
		if current_level.name.begins_with("Level"):
			SoundManager.change_music_stream(SoundManager.COMBAT_LEVEL)
		
		current_scene.get_child(0).queue_free()
		current_scene.add_child(instance)


#region COMBAT SIGNALS
func _on_start_combat(enemy: Enemy) -> void:
	PlayerData.toggle_is_in_combat()
	# hide the current level
	current_level.visible = false
	current_enemy = enemy
	
	# get the combat scene and add it to the canvas layer because the
	# combat scene is a ui scene
	var combat_scene = COMBAT_TSCN.instantiate()
	canvas_layer.add_child(combat_scene, true)


func _on_end_combat() -> void:
	PlayerData.toggle_is_in_combat()
	# after the combat has ended make the current level visible again
	current_level.visible = true
	# free the enemy when ending combat
	current_enemy.queue_free()
	
	# remove the combat scene
	for child in canvas_layer.get_children():
		if child.name == &"Combat":
			child.queue_free()
#endregion


#region DIALOGUE LOGIC
func _on_entered_dialogue_area(npc: NPC) -> void:
	PlayerData.can_talk = true
	current_npc = npc


func _on_exited_dialogue_area() -> void:
	PlayerData.can_talk = false
	current_npc = null
#endregion


#region INTERACTABLE SIGNALS
func _on_entered_interactable_area(scene_to_change: PackedScene) -> void:
	interactable_scene_change = scene_to_change
	PlayerData.can_interact = true
	
func _on_exited_interactable_area() -> void:
	interactable_scene_change = null
	PlayerData.can_interact = false
#endregion
