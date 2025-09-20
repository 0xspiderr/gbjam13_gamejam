extends Node2D

@export var itemStats: ItemStats
@export var button: Button
@onready var itemCost: Label = $CostValue
@onready var sprite: Sprite2D = $Sprite

var item_name: String
var cost: int
var stats_to_mod: Dictionary[String, int]

func _ready() -> void:
	button = $Button

func Init(stats):
	itemStats = stats
	item_name = itemStats.name
	cost = itemStats.cost; itemCost.text = str(cost)
	stats_to_mod = itemStats.stats_to_mod
	sprite.frame = itemStats.icon_frame

func Equip():
	for mod in stats_to_mod.keys():
		match mod: # modifies a particular stat
			"luck":
				PlayerData.luck = stats_to_mod.get(mod)
			"attack":
				PlayerData.extra_damage = stats_to_mod.get(mod)
			"max health":
				PlayerData.extra_health = stats_to_mod.get(mod)
			"speed":
				PlayerData.extra_speed = stats_to_mod.get(mod)
			_: # unhandled stat - does nothing
				pass
