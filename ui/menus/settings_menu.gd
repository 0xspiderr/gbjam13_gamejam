extends Control

enum
{
	BACK = 0,
	VOLUME_SLIDER = 1,
	BRIGHTNESS_SLIDER = 2
}

@onready var volume_label: Label = $MarginContainer/Panel/VBoxContainer/Volume_Label
@onready var volume_slider: HSlider = $MarginContainer/Panel/VBoxContainer/Volume_Slider
@onready var back_button: Button = $MarginContainer/Panel/VBoxContainer/Back_Button
@onready var brightness_label: Label = $MarginContainer/Panel/VBoxContainer/Brightness_Label
@onready var brightness_slider: HSlider = $MarginContainer/Panel/VBoxContainer/Brightness_Slider
var ui_elems: Array[Control] = []
var index: int = 0


func _ready() -> void:
	ui_elems.append(back_button)
	ui_elems.append(volume_slider)
	ui_elems.append(brightness_slider)
	ui_elems[index].grab_focus.call_deferred()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		index +=1
		if index >= ui_elems.size():
			index = 0
	
	if event.is_action_pressed("up"):
		index -=1
		if index <= 0:
			index = ui_elems.size() - 1
	
	if event.is_action_pressed("interact"):
		_do_action_on_control()
	
	if ui_elems[index] is HSlider:
		if ui_elems[index].name == "Volume_Slider":
			if event.is_action_pressed("right"):
				if volume_slider.value <= 100:
					volume_slider.value += 5
					AudioServer.set_bus_volume_db(0, linear_to_db(float(volume_slider.value / 100)))
			
			if event.is_action_pressed("left"):
				if volume_slider.value - 5 >= 0:
					volume_slider.value -= 5
					AudioServer.set_bus_volume_db(0, linear_to_db(float(volume_slider.value / 100)))
		elif ui_elems[index].name == "Brightness_Slider":
			if event.is_action_pressed("right"):
				if brightness_slider.value<=100:
					brightness_slider.value +=5
			if event.is_action_pressed("left"):
				if brightness_slider.value - 5 >= 0:
					brightness_slider.value -=5
	if is_inside_tree():
		ui_elems[index].grab_focus()

func _do_action_on_control() -> void:
	match index:
		VOLUME_SLIDER:
			pass
		BRIGHTNESS_SLIDER:
			pass
		BACK:
			_on_back_button_pressed()


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
