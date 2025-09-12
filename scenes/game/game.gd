class_name Game
extends Node


@onready var player: Player = $Player


func _ready() -> void:
	EventBus.start_combat.connect(_on_start_combat)


func _on_start_combat() -> void:
	print("combat started")
	
