extends Control

enum
{
	BACK = 0,
	VOLUME_SLIDER = 1
}

@onready var volume_label: Label = $MarginContainer/Panel/VBoxContainer/Volume_Label
@onready var volume_slider: HSlider = $MarginContainer/Panel/VBoxContainer/Volume_Slider
@onready var back_button: Button = $MarginContainer/Panel/VBoxContainer/Back_Button
var ui_elems: Array[Control] = []
var index: int = 0


func _ready() -> void:
	ui_elems.append(back_button)
	ui_elems.append(volume_slider)
	ui_elems[index].grab_focus.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		if index >= ui_elems.size() - 1:
			index = 0
	
	if event.is_action_pressed("up"):
		if index <= 0:
			index = ui_elems.size() - 1
	
	if event.is_action_pressed("interact"):
		_do_action_on_control()
	
	if ui_elems[index] is HSlider:
		if event.is_action_pressed("right"):
			if volume_slider.value <= 100:
				volume_slider.value += 5
				AudioServer.set_bus_volume_db(0, linear_to_db(float(volume_slider.value / 100)))
		
		if event.is_action_pressed("left"):
			if volume_slider.value - 5 >= 0:
				volume_slider.value -= 5
				AudioServer.set_bus_volume_db(0, linear_to_db(float(volume_slider.value / 100)))
		
	if is_inside_tree():
		ui_elems[index].grab_focus.call_deferred()

func _do_action_on_control() -> void:
	match index:
		VOLUME_SLIDER:
			pass
		BACK:
			_on_back_button_pressed()


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
