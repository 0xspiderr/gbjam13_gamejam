extends Node2D

@export var item_list:Array[ItemStats]
@onready var itemCollection = $Items # placeholder
@onready var changePage: Array[Button] = [$"../Prev", $"../Next"]
var focusedButton: Button
var focusSection:String
var currentPage:int
var currentItem:int
@export var popupOpen:bool = false

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
	focusSection = "change_page"
	SetFocus(changePage[0], focusSection)

func _process(delta: float) -> void:
	# input handling
	if popupOpen == false:
		if Input.is_action_just_pressed("left"):
			if focusSection == "change_page": # change page section
				SetFocus(changePage[0], focusSection)
			else: # item section
				if currentItem > 0:
					currentItem -= 1
					SetFocus(itemCollection.get_child(currentItem).find_child("Button"), focusSection)
		if Input.is_action_just_pressed("right"):
			if focusSection == "change_page": # change page section
				SetFocus(changePage[1], focusSection)
			else: # item section
				if currentItem < 2:
					currentItem += 1
					SetFocus(itemCollection.get_child(currentItem).find_child("Button"), focusSection)
		if Input.is_action_just_pressed("up"):
			if focusSection != "change_page":
				focusSection = "change_page"
				SetFocus(changePage[1], focusSection)
		if Input.is_action_just_pressed("down"):
			if focusSection != "item_list":
				focusSection = "item_list"
				currentItem = 0
				SetFocus(itemCollection.get_child(currentItem).find_child("Button"), focusSection)
		if Input.is_action_just_pressed("interact"):
			if focusedButton != null:
				focusedButton.pressed.emit()
		if Input.is_action_just_pressed("exit"):
			PlayerData.is_shopping = false
			get_parent().queue_free()

func SetFocus(button: Button, section:Variant):
	button.grab_focus()
	if section != "change_page":
		focusedButton = button
		popupOpen = true
		focusedButton.pressed.connect(_on_item_pressed)
		popupOpen = false # weird ahh fix so sognal doesnt autofire
	else: # does not connect signals for change page - signals are alradey connected
		if focusedButton != null:
			focusedButton.pressed.disconnect(_on_item_pressed)
		focusedButton = null

func AddPopup(item):
	var popup = load("res://scenes/shop/shop_popup.tscn").instantiate()
	add_child(popup)
	popup.Init(item)

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
	if popupOpen == false:
		AddPopup(itemCollection.get_child(currentItem))
		popupOpen = true
