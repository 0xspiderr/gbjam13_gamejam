extends Node2D

@export var itemStats: ItemStats
@onready var button: Button = $Button
@onready var itemCost: Label = $CostValue
@onready var sprite: Sprite2D = $Sprite

var item_name: String
var cost: int
var stats_to_mod: Dictionary[String, int]

func Init(stats):
	itemStats = stats
	item_name = itemStats.name
	cost = itemStats.cost; itemCost.text = str(cost)
	stats_to_mod = itemStats.stats_to_mod
	sprite.frame = itemStats.icon_frame
