extends Control


@onready var boot_splash: AnimatedSprite2D = $BootSplash
const DISCLAIMER_SCENE = preload("res://ui/disclaimer_scene/disclaimer_scene.tscn")


func _ready() -> void:
	boot_splash.play(&"default")


func _on_boot_splash_animation_finished() -> void:
	get_tree().change_scene_to_packed(DISCLAIMER_SCENE)
