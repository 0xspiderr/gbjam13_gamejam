extends Control

@onready var panel: Panel = $Panel
@onready var luck: Node2D = $Panel/Luck
@onready var money: Node2D = $Panel/Money
@onready var key_1: Sprite2D = $Key1
@onready var key_2: Sprite2D = $Key2

@onready var current_theme:String = "overworld"

func ChangeTheme(new_theme, theme_string):
	current_theme = theme_string
	panel.theme = new_theme
	luck.find_child("Text").theme = new_theme
	money.find_child("Text").theme = new_theme
	match current_theme:
		"overworld":
			luck.find_child("Icon").texture = load("res://assets/ui_icons/luck_icon.png")
			money.find_child("Icon").texture = load("res://assets/ui_icons/money_icon.png")
			key_1.texture = load("res://assets/ui_icons/key-icon.png")
			key_2.texture = load("res://assets/ui_icons/key-icon.png")
		"combat":
			luck.find_child("Icon").texture = load("res://assets/ui_icons/luck_icon_recolor.png")
			money.find_child("Icon").texture = load("res://assets/ui_icons/money_icon_recolored.png")
			key_1.texture = load("res://assets/ui_icons/key-icon-recolored.png")
			key_2.texture = load("res://assets/ui_icons/key-icon-recolored.png")

func UpdateLuck(new):
	luck.find_child("Text").text = str(new)

func UpdateMoney(new):
	money.find_child("Text").text = str(new)

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
