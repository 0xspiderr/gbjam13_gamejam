class_name DialogueChoices
extends Control


signal start_dialogue()
signal open_shop()


var choices: Array
@export var buttons: Array[Button]
var current_button: int = 0


func _input(event: InputEvent) -> void:
	if not PlayerData.is_selecting_choice or PlayerData.is_talking or PlayerData.is_shopping:
		return
	
	if event.is_action_pressed("interact"):
		_change_scene(choices[current_button])
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("up"):
		_increment_button_index(-1)
	
	if event.is_action_pressed("down"):
		_increment_button_index(1)


func _increment_button_index(num: int) -> void:
	if num < 0:
		if current_button == 0:
			current_button = choices.size() - 1
		else:
			current_button -= 1
	else:
		current_button = (current_button + 1) % choices.size()
	
	buttons[choices[current_button]].grab_focus.call_deferred()


func show_choice_buttons() -> void:
	PlayerData.is_selecting_choice = true
	buttons[0].grab_focus.call_deferred()
	for choice in choices:
		buttons[choice].show()


func hide_all_buttons() -> void:
	for button in buttons:
		button.hide()


func _change_scene(choice: int) -> void:
	match choice:
		0:
			reset_data()
			start_dialogue.emit()
		1:
			reset_data()
			open_shop.emit()
		2:
			reset_data()
	
	print(choice)


func reset_data() -> void:
	current_button = 0
	hide_all_buttons()
	hide()
	PlayerData.is_selecting_choice = false
