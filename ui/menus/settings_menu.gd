extends Control

enum
{
	VOLUME_LABEL = 0,
	VOLUME_SLIDER = 1,
	BACK = 2
}

@onready var volume_label: Label = $MarginContainer/Panel/VBoxContainer/Volume_Label
@onready var volume_slider: HSlider = $MarginContainer/Panel/VBoxContainer/Volume_Slider
@onready var back_button: Button = $MarginContainer/Panel/VBoxContainer/Back_Button

const MAIN_MENU = preload("res://ui/menus/main_menu.tscn")

func _on_volume_slider_value_changed(value):
	pass # Replace with function body.


func _on_back_button_pressed():
	var menu = MAIN_MENU.instantiate()
	get_tree().change_scene_to_packed(menu)
