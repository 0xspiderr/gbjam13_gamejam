extends Control


const MAIN_MENU = preload("uid://bgasbu3xvl0ur")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		get_tree().change_scene_to_packed(MAIN_MENU)
