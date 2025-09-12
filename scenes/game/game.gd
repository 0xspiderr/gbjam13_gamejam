class_name Game
extends Node


@onready var current_scene: Node = $CurrentScene
@onready var canvas_layer: CanvasLayer = $CanvasLayer

const COMBAT_TSCN: PackedScene = preload("res://scenes/combat/combat.tscn")


func _ready() -> void:
	EventBus.start_combat.connect(_on_start_combat)


#region COMBAT SIGNALS
func _on_start_combat() -> void:
	var scene: Node = null
	# get the current loaded level scene and free it
	if current_scene.get_child_count():
		scene = current_scene.get_child(0)
	
	if is_instance_valid(scene):
		scene.queue_free()
	
	# get the combat scene and add it to the canvas layer because the
	# combat scene is a ui scene
	var combat_scene = COMBAT_TSCN.instantiate()
	canvas_layer.add_child(combat_scene, true)

#endregion
