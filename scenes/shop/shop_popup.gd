extends Node2D

@onready var stat_modifiers: Node2D 
@onready var item_name: Label 
@onready var item_icon: Sprite2D 
@onready var buy_for_cost: Label 
@onready var buttons: Node2D 
var item_scene:Variant

var statMods:Dictionary[String, int]

func _ready():
	stat_modifiers = $Panel/StatModifiers
	item_name = $Panel/ItemName
	item_icon = $Panel/ItemIcon
	buy_for_cost = $BuyForCost
	buttons = $Buttons

func Init(base:Variant):
	item_scene = base
	var item:ItemStats = item_scene.itemStats
	item_name.text = item.name
	item_icon.frame = item.icon_frame
	buy_for_cost.text = "Buy for " + str(item.cost) + " coins?"
	statMods = item.stats_to_mod
	var y = 4
	for mod in statMods.keys():
		AddStatMod(mod,y)
		y += 13
	buttons.get_child(0).grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		buttons.get_child(0).grab_focus()
	if Input.is_action_just_pressed("right"):
		buttons.get_child(1).grab_focus()

func AddStatMod(mod,y):
	var statLabel = Label.new()
	statLabel.position.y = y
	statLabel.text = "+" + str(statMods.get(mod)) + " " + mod
	stat_modifiers.add_child(statLabel)


func _on_yes_pressed() -> void: # buy item
	if PlayerData.money >= item_scene.itemStats.cost:
		PlayerData.money -= item_scene.itemStats.cost
		item_scene.Equip()
		get_parent().popupOpen = false
		self.queue_free()
	else:
		buy_for_cost.text = "Not enough coins!"


func _on_no_pressed() -> void: # do not buy
	get_parent().popupOpen = false
	self.queue_free()
