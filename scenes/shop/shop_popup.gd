extends Node2D

@onready var stat_modifiers: Node2D = $Panel/StatModifiers
@onready var item_name: Label = $Panel/ItemName
@onready var item_icon: Sprite2D = $Panel/ItemIcon
@onready var buy_for_cost: Label = $BuyForCost
@onready var buttons: Node2D = $Buttons

var statMods:Dictionary[String, int]

func Init(item:ItemStats):
	item_name.text = item.name
	item_icon.frame = item.icon_frame
	buy_for_cost.text = "Buy for " + str(item.cost) + " coins?"
	statMods = item.stats_to_mod
	var y = 4
	for mod in statMods.keys():
		AddStatMod(mod,y)
		y += 13

func AddStatMod(mod,y):
	var statLabel = Label.new()
	statLabel.position.y = y
	statLabel.text = "+" + str(statMods.get(mod)) + " " + mod
	stat_modifiers.add_child(statLabel)


func _on_yes_pressed() -> void:
	self.queue_free()


func _on_no_pressed() -> void:
	self.queue_free()
