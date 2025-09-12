extends Node


var luck: float = 0.0
var is_in_combat: bool = false


func toggle_is_in_combat() -> void:
	is_in_combat = !is_in_combat
