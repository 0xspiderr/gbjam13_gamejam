extends Node


var max_health: int = 100
var current_health: int = 100
var extra_health:int = 0
var speed:float = 100.0
var extra_speed:float = 0.0
var damage: int = 10
var extra_damage:int = 0
var luck: float = 0.0
var is_in_combat: bool = false
var is_in_combat_level = false
var is_shopping: bool = false
var can_talk: bool = false
var is_talking: bool = false
var is_selecting_choice: bool = false
var can_interact: bool = false
var money: int = 100
var keys_obtained:int = 0


func toggle_is_in_combat() -> void:
	is_in_combat = !is_in_combat
