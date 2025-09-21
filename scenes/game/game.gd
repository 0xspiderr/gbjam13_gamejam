class_name Game
extends Node


@onready var current_scene: Node = $CurrentScene
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var scene_transition: SceneTransition = $SceneTransition

var current_level: Node2D = null
var current_enemy: Enemy = null
var current_npc: NPC = null
var interactable_scene_change: PackedScene = null

const COMBAT_TSCN: PackedScene = preload("uid://cnseaei7cyk0j")
@onready var dialogue_ui: DialogueUI = %DialogueUI
@onready var dialogue_choices: DialogueChoices = %DialogueChoices
const SHOP_SCENE = preload("res://scenes/shop/shop_scene.tscn")
const LEVEL_0 = preload("res://scenes/levels/level0.tscn")


#region BUILTIN METHODS
func _ready() -> void:
	SoundManager.change_music_stream(SoundManager.OVERWORLD)
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished)
	dialogue_choices.start_dialogue.connect(_on_start_dialogue)
	dialogue_choices.open_shop.connect(_on_open_shop)
	
	EventBus.start_combat.connect(_on_start_combat)
	EventBus.end_combat.connect(_on_end_combat)
	EventBus.entered_dialogue_area.connect(_on_entered_dialogue_area)
	EventBus.exited_dialogue_area.connect(_on_exited_dialogue_area)
	EventBus.entered_interactable_area.connect(_on_entered_interactable_area)
	EventBus.exited_interactable_area.connect(_on_exited_interactable_area)


func _input(event: InputEvent) -> void:
	# dont process player input if in combat or if talking
	# to an npc.
	if PlayerData.is_in_combat or PlayerData.is_talking or PlayerData.is_selecting_choice or \
	PlayerData.is_shopping:
		return
	
	if event.is_action_pressed("interact"):
		if PlayerData.can_interact:
			_change_level_scene(interactable_scene_change)
		
		if PlayerData.can_talk and is_instance_valid(current_npc):
			dialogue_choices.choices = current_npc.npc_stats.dialogue_options
			dialogue_choices.show_choice_buttons()
			dialogue_choices.show()
	
	if event.is_action_pressed("exit"): 
		var scene = current_scene.get_child(0) as Node2D
		# allow exit only out of minigame levels when pressing the exit action,
		# minigames dont start with "Level".
		if not scene.name.begins_with("Level"):
			current_scene.get_child(0).queue_free()
			current_scene.add_child(current_level)
#endregion


func _on_start_dialogue() -> void:
	PlayerData.is_talking = true
	dialogue_ui.set_to_theme(false)
	dialogue_ui.npc_name.text = current_npc.name
	dialogue_ui.dialogues.assign(current_npc.npc_stats.dialogues)
	dialogue_ui.npc_sprites.sprite_frames = current_npc.npc_stats.portraits
	dialogue_ui.dialogue_box.audio_stream_player.stream = current_npc.npc_stats.dialogue_stream
	dialogue_ui.visible = true


func _on_open_shop() -> void:
	PlayerData.is_shopping = true
	var instance = SHOP_SCENE.instantiate()
	canvas_layer.add_child(instance)


func _get_current_level() -> void:
	if current_scene.get_child_count():
		current_level = current_scene.get_child(0)


func _change_level_scene(scene: PackedScene) -> void:
	if current_scene.get_child_count():
		var instance
		if scene == null:
			instance = LEVEL_0.instantiate()
		else:
			instance = scene.instantiate()
		
		if scene == null:
			SoundManager.change_music_stream(SoundManager.OVERWORLD)
			scene_transition.set_rect_color(false)
		elif instance.name.begins_with("Level"):
			SoundManager.change_music_stream(SoundManager.COMBAT_LEVEL)
			scene_transition.set_rect_color(true)
		
		scene_transition.play_transitions()
		await get_tree().create_timer(0.5).timeout
		current_level = current_scene.get_child(0).duplicate()
		current_scene.get_child(0).queue_free()
		current_scene.add_child(instance)
		


#region COMBAT SIGNALS
func _on_start_combat(enemy: Enemy) -> void:
	PlayerData.toggle_is_in_combat()
	current_enemy = enemy
	
	scene_transition.set_rect_color(true)
	scene_transition.play_transitions()
	await get_tree().create_timer(0.5).timeout
	
	dialogue_ui.set_to_theme(true)
	if is_instance_valid(current_enemy):
		if is_instance_valid(current_enemy.npc_stats):
			PlayerData.is_talking = true
			dialogue_ui.npc_name.text = current_enemy.npc_stats.name
			dialogue_ui.dialogues.assign(current_enemy.npc_stats.dialogues)
			dialogue_ui.npc_sprites.sprite_frames = current_enemy.npc_stats.portraits
			dialogue_ui.dialogue_box.audio_stream_player.stream = current_enemy.npc_stats.dialogue_stream
			dialogue_ui.visible = true
		else:
			# hide the current level
			current_level.visible = false
			# get the combat scene and add it to the canvas layer because the
			# combat scene is a ui scene
			var combat_scene = COMBAT_TSCN.instantiate()
			combat_scene.player_death.connect(_on_player_death)
			combat_scene.enemy_death.connect(_on_enemy_death)
			combat_scene.enemy_stats = current_enemy.stats
			canvas_layer.add_child(combat_scene, true)


func _on_dialogue_finished() -> void:
	# change to combat level after dialogue, only if we are interacting
	# with an enemy.
	if is_instance_valid(current_enemy):
		# hide the current level
		current_level.visible = false
		# get the combat scene and add it to the canvas layer because the
		# combat scene is a ui scene
		var combat_scene = COMBAT_TSCN.instantiate()
		
		combat_scene.enemy_stats = current_enemy.stats
		canvas_layer.add_child(combat_scene, true)
		combat_scene.player_death.connect(_on_player_death)
		combat_scene.enemy_death.connect(_on_enemy_death)


func _on_player_death() -> void:
	canvas_layer.get_child(2).queue_free()
	current_scene.get_child(0).queue_free()
	current_scene.add_child(LEVEL_0.instantiate())
	PlayerData.current_health = PlayerData.max_health
	PlayerData.money=max((PlayerData.money-20),0)
	print("you die")
	PlayerData.is_in_combat = false
	
func _on_enemy_death() -> void:
	current_enemy.queue_free()
	canvas_layer.get_child(2).queue_free()
	PlayerData.money=PlayerData.money+randi_range(10,50)+floori(randi_range(0,10)*PlayerData.luck)
	print("enemy die")
	PlayerData.is_in_combat = false
	

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
	
	# temporary solution until combat is implemented
	if current_level.name.begins_with("Level"):
		SoundManager.change_music_stream(SoundManager.COMBAT_LEVEL)
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
