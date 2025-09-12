extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.start_combat.emit()
		# free this enemy from the level when starting combat
		get_parent().queue_free()
