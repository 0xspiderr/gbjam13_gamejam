extends Node2D

@export var item_list:Array[ItemStats]
@onready var itemCollection = $Items # placeholder
@onready var changePage: Array[Button] = [$"../Prev", $"../Next"]
var focusedButton: Button

func ShowItems(startIndex):
	for ind in range(0, 3):
		AddItem(4 + 50 * ind, 90, startIndex + ind)

func ClearItems():
	for child in itemCollection.get_children():
		child.queue_free()

func AddItem(x, y, index):
	var item = load("res://scenes/shop/shop_item.tscn").instantiate()
	itemCollection.add_child(item)
	item.Init(item_list[index])
	item.position.x = x
	item.position.y = y

func _ready() -> void:
	ShowItems(0)
	focusedButton = changePage[0]

func _process(delta: float) -> void:
	# input handling
	if Input.is_action_just_pressed("left"):
		SetFocus(changePage[0])
	if Input.is_action_just_pressed("right"):
		SetFocus(changePage[1])
	if Input.is_action_just_pressed("interact"):
		focusedButton.pressed.emit()

func SetFocus(button: Button):
	button.grab_focus()
	focusedButton = button

func _on_prev_pressed() -> void:
	print_debug("left bruh")


func _on_next_pressed() -> void:
	print_debug("right bruh")
