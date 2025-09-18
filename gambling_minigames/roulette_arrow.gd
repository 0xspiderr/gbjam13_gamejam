extends Node2D

signal stop(col)
var color
var wheel

func Init(obj):
	wheel = obj

func SetColorToStop(col):
	color = col

func _on_area_entered(area: Area2D) -> void:
	if wheel.rotateSpeed < 0.8:
		if area.is_in_group("roulette_slice_black") and color == 0:
			emit_signal("stop", color)
		elif area.is_in_group("roulette_slice_pink") and color == 1:
			emit_signal("stop", color)
