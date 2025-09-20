extends Node


var max_health: int = 100
var current_health: int = 1
var damage: int = 1
var luck: float = 0.0
var is_in_combat: bool = false
var can_talk: bool = false
var is_talking: bool = false
var can_interact: bool = false
var money: int = 100 # to test minigames


func toggle_is_in_combat() -> void:
	is_in_combat = !is_in_combat
