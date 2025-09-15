extends Node


@export var tween_scale_up: Vector2 = Vector2(1.0, 1.0)
@export var tween_scale_down: Vector2 = Vector2(0.9, 0.9)


#region TWEENS
func _tween_btn_scale(button: Button) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", tween_scale_down, 0.2)
	tween.tween_property(button, "scale", tween_scale_up, 0.2)
#endregion
