extends Node2D

var totalMoney
var moneyToBet


func _ready() -> void:
	totalMoney = PlayerData.money


func _on_prev_pressed() -> void:
	var file = FileAccess.open("res://data.txt", FileAccess.WRITE)
	PlayerData.money = totalMoney
	get_tree().change_scene_to_file("res://gambling_minigames/slots_minigame.tscn")


func _on_next_pressed() -> void:
	var file = FileAccess.open("res://data.txt", FileAccess.WRITE)
	PlayerData.money = totalMoney
	get_tree().change_scene_to_file("res://gambling_minigames/blackjack_minigame.tscn")
