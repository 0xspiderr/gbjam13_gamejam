class_name Game
extends Node


@onready var current_scene: Node = $CurrentScene
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var current_level: Node2D = null
var current_enemy: Enemy = null
const COMBAT_TSCN: PackedScene = preload("uid://cnseaei7cyk0j")


#region BUILTIN METHODS
func _ready() -> void:
	EventBus.start_combat.connect(_on_start_combat)
	EventBus.end_combat.connect(_on_end_combat)
	_get_current_level()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
#endregion


func _get_current_level() -> void:
	if current_scene.get_child_count():
		current_level = current_scene.get_child(0)


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
	var combat_scene = canvas_layer.get_child(0)
	if is_instance_valid(combat_scene):
		combat_scene.queue_free()

#endregion
