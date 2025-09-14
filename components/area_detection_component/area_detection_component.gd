class_name AreaDetectionComponent
extends Area2D


signal body_colliding()
signal body_exited_collision()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var enemy = get_parent() as Enemy
		EventBus.start_combat.emit(enemy)
