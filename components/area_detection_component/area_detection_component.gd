extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var enemy = get_parent() as Enemy
		EventBus.start_combat.emit(enemy)
	
