extends Node2D

signal slow_down(delta)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("roulette_slice"):
		emit_signal("slow_down", 0.1)
