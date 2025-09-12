extends Control


func _ready() -> void:
	pass


func _on_test_btn_pressed() -> void:
	EventBus.end_combat.emit()
