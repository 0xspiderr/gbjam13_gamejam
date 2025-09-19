extends Node2D

@export var item_list:Array[ItemStats]
@onready var itemCollection = $Items # placeholder
@onready var changePage: Array[Button] = [$"../Prev", $"../Next"]
var focusedButton: Button
var currentPage:int
var currentItem:int

func ShowItems(startIndex):
	for ind in range(0, 3):
		AddItem(4 + 50 * ind, 90, startIndex + ind)

func ClearItems():
	for child in itemCollection.get_children():
		child.queue_free()

func AddItem(x, y, index):
	if index < item_list.size():
		var item = load("res://scenes/shop/shop_item.tscn").instantiate()
		itemCollection.add_child(item)
		item.Init(item_list[index])
		item.position.x = x
		item.position.y = y

func _ready() -> void:
	currentPage = 0
	currentItem = 0
	ShowItems(currentPage * 3)
	focusedButton = changePage[0]

func _process(delta: float) -> void:
	# input handling
	if Input.is_action_just_pressed("left"):
		SetFocus(changePage[0], null)
	if Input.is_action_just_pressed("right"):
		SetFocus(changePage[1], null)
	if Input.is_action_just_pressed("up"):
		SetFocus(changePage[1], null)
	if Input.is_action_just_pressed("down"):
		SetFocus(changePage[1], null)
	if Input.is_action_just_pressed("interact"):
		if focusedButton != null:
			focusedButton.pressed.emit()

func SetFocus(button: Button, section:Variant):
	button.grab_focus()
	if section != null:
		focusedButton = button
	else:
		focusedButton = null

func AddPopup(item):
	

func _on_prev_pressed() -> void:
	if currentPage > 0:
		currentPage -= 1
		ClearItems()
		ShowItems(currentPage * 3)

func _on_next_pressed() -> void:
	if currentPage < ((item_list.size() / 3) + (0 if item_list.size() % 3 == 0 else 1) -1):
		currentPage += 1
		ClearItems()
		ShowItems(currentPage * 3)

func _on_item_pressed():
	pass
