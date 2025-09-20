extends Control


enum
{
	PLAY = 0,
	SETTINGS = 1,
	QUIT = 2
}
@export var tween_scale_up: Vector2 = Vector2(1.15, 1.15)
@export var tween_scale_down: Vector2 = Vector2(1.0, 1.0)

@onready var v_box_buttons: VBoxContainer = %VBoxButtons
@onready var play_btn: Button = %PlayBtn
@onready var settings_btn: Button = %SettingsBtn
@onready var quit_btn: Button = %QuitBtn
var buttons: Array[Button] = []
var current_button: int = 0


const GAME_INTRO = preload("uid://fy8rujvdasrg")
const SETTINGS_MENU = preload("uid://34c4qwkglvv")

func _ready() -> void:
	SoundManager.change_music_stream(SoundManager.MAIN_MENU_OGG)
	buttons.append(play_btn)
	buttons.append(settings_btn)
	buttons.append(quit_btn)
	
	buttons[current_button].grab_focus.call_deferred()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_change_menu(current_button)
	
	if event.is_action_pressed("up"):
		_increment_button_index(-1)
	
	if event.is_action_pressed("down"):
		_increment_button_index(1)


func _increment_button_index(num: int) -> void:
	if num < 0:
		if current_button == 0:
			current_button = 2
		else:
			current_button -= 1
	else:
		current_button = (current_button + 1) % 3
	
	buttons[current_button].grab_focus.call_deferred()


func _tween_btn_scale_up(button: Button) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", tween_scale_up, 0.2)

func _tween_btn_scale_down(button: Button) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(button, "scale", tween_scale_down, 0.2)

 
func _change_menu(button_index: int) -> void:
	match button_index:
		PLAY:
			get_tree().change_scene_to_packed(GAME_INTRO)
		SETTINGS:
			get_tree().change_scene_to_packed(SETTINGS_MENU)
		QUIT:
			get_tree().quit()
		_:
			print("oops")
