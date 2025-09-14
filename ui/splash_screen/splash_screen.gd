extends Control


@onready var boot_splash: AnimatedSprite2D = $BootSplash
const MAIN_MENU = preload("res://ui/menus/main_menu.tscn")


func _ready() -> void:
	boot_splash.play(&"default")


func _on_boot_splash_animation_finished() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
