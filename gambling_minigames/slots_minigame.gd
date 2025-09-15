extends Node2D

var totalMoney
var totalMoneyText
var moneyToBet
var moneyToBetText
var state
var timer
var gameStatus
var playButton
var betAdjust

var slotsArray
var slotsRefreshArray
var currSlotIndex

func UpdateBet(new):
	moneyToBet = new
	moneyToBetText.text = str(moneyToBet)

func UpdateTotal(new):
	totalMoney = new
	totalMoneyText.text = str(totalMoney)

func UpdateState(new):
	state = new
	match state:
		1:
			gameStatus.text = ""
			ResetSlots([10,10,10])
			playButton.disabled = true
			betAdjust.find_child("Raise").disabled = true
			betAdjust.find_child("Lower").disabled = true
			timer.start()
		2:
			gameStatus.text = "YOU WIN"
			UpdateTotal(totalMoney + 7 * moneyToBet)
			playButton.disabled = false
			betAdjust.find_child("Raise").disabled = false
			betAdjust.find_child("Lower").disabled = false
		3:
			gameStatus.text = "WOMP WOMP"
			playButton.disabled = false
			betAdjust.find_child("Raise").disabled = false
			betAdjust.find_child("Lower").disabled = false

func ResetSlots(array):
	for slot in slotsArray:
		slot.Update("")
	slotsRefreshArray = array
	currSlotIndex = 0

func RollSlot():
	if slotsRefreshArray[currSlotIndex] > 0:
		slotsArray[currSlotIndex].Update(str(randi_range(1,7)))
		slotsRefreshArray[currSlotIndex] -= 1
	else:
		currSlotIndex += 1
		if currSlotIndex > slotsArray.size() - 1:
			CheckSlots()

func CheckSlots():
	var init = slotsArray[0].numValue
	if slotsArray.all(func(slot): return slot.numValue == init) == true:
		UpdateState(2)
	else:
		UpdateState(3)


func _ready() -> void:
	totalMoneyText = $Footer/BetPanel/Total/Value
	moneyToBetText = $Footer/BetPanel/Bet/Value
	slotsArray = [$Slots/Card, $Slots/Card2, $Slots/Card3]
	timer = $Timer
	gameStatus = $GameStatus
	playButton = $Footer/Play
	betAdjust = $Footer/BetAdjust
	ResetSlots([10,10,10]) # nr of refreshes before result, purely visual
	
	UpdateBet(5)
	UpdateTotal(int(FileAccess.open("res://data.txt", FileAccess.READ).get_line())) # total money

func _on_prev_pressed() -> void:
	var file = FileAccess.open("res://data.txt", FileAccess.WRITE)
	file.store_line(str(totalMoney))
	get_tree().change_scene_to_file("res://gambling_minigames/blackjack_minigame.tscn")


func _on_next_pressed() -> void:
	var file = FileAccess.open("res://data.txt", FileAccess.WRITE)
	file.store_line(str(totalMoney))
	get_tree().change_scene_to_file("res://gambling_minigames/roulette_minigame.tscn")


func _on_raise_pressed() -> void:
	if moneyToBet < 100:
		UpdateBet(moneyToBet + 5)


func _on_lower_pressed() -> void:
	if moneyToBet > 5:
		UpdateBet(moneyToBet - 5)


func _on_play_pressed() -> void:
	UpdateTotal(totalMoney - moneyToBet)
	UpdateState(1)


func _on_timer_timeout() -> void:
	if state == 1:
		RollSlot()
		timer.start()
