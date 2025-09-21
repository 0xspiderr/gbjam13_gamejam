class_name StatUI
extends Control

@onready var panel: Panel = $Panel
@onready var luck_icon: Sprite2D = $Luck/Icon
@onready var luck_text: Label = $Luck/Text
@onready var money_text: Label = $Money/Text
@onready var money_icon: Sprite2D = $Money/Icon
@onready var key_1: Sprite2D = $Key1
@onready var key_2: Sprite2D = $Key2

const OVERWORLD_OUTLINE = Color("6372b4")
const COMBAT_OUTLINE = Color("6a605b")

@onready var current_theme:String = "overworld"

func ChangeTheme(new_theme, theme_string):
	current_theme = theme_string
	panel.theme = new_theme
	luck_text.theme = new_theme; 
	money_text.theme = new_theme
	match current_theme:
		"overworld":
			luck_text.add_theme_color_override("font_outline_color", OVERWORLD_OUTLINE)
			money_text.add_theme_color_override("font_outline_color", OVERWORLD_OUTLINE)
			luck_icon.texture = preload("res://assets/ui_icons/luck_icon.png")
			money_icon.texture = preload("res://assets/ui_icons/money-icon.png")
			key_1.texture = load("res://assets/ui_icons/key-icon.png")
			key_2.texture = load("res://assets/ui_icons/key-icon.png")
		"combat":
			luck_text.add_theme_color_override("font_outline_color", COMBAT_OUTLINE)
			money_text.add_theme_color_override("font_outline_color", COMBAT_OUTLINE)
			luck_icon.texture = preload("res://assets/ui_icons/luck_icon-recolor.png")
			money_icon.texture = preload("res://assets/ui_icons/money-icon-recolored.png")
			key_1.texture = load("res://assets/ui_icons/key-icon-recolored.png")
			key_2.texture = load("res://assets/ui_icons/key-icon-recolored.png")

func UpdateLuck(new):
	luck_text.text = str(new)

func UpdateMoney(new):
	money_text.text = str(new)

func Show():
	self.visible = true
	UpdateLuck(int(PlayerData.luck))
	UpdateMoney(PlayerData.money)

func Hide():
	self.visible = false

func ShowKey(key):
	match key:
		1:
			key_1.visible = true
		2:
			key_2.visible = true
