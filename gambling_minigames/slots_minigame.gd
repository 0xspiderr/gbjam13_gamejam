extends Node2D

var totalMoney
var totalMoneyText
var moneyToBet
var moneyToBetText
var playButton
var betAdjust
var winMUlt

var slotsArray
var slotsRefreshArray = [7,7,12]
var slotsEngine

func UpdateBet(new):
	moneyToBet = new
	moneyToBetText.text = str(moneyToBet)

func UpdateTotal(new):
	totalMoney = new
	PlayerData.money = totalMoney
	totalMoneyText.text = str(totalMoney)

func _on_state_changed() -> void:
	match slotsEngine.state:
		1:
			playButton.disabled = true
			betAdjust.find_child("Raise").disabled = true
			betAdjust.find_child("Lower").disabled = true
		2:
			UpdateTotal(totalMoney + slotsEngine.winMultiplier * moneyToBet)
			playButton.disabled = false
			betAdjust.find_child("Raise").disabled = false
			betAdjust.find_child("Lower").disabled = false
		3:
			playButton.disabled = false
			betAdjust.find_child("Raise").disabled = false
			betAdjust.find_child("Lower").disabled = false


func _ready() -> void:
	totalMoneyText = $BetPanel/Total/Value
	moneyToBetText = $BetPanel/Bet/Value
	slotsArray = [$Slots/Slot, $Slots/Slot2, $Slots/Slot3]
	playButton = $Footer/Play
	betAdjust = $Footer/BetAdjust
	slotsEngine = $SlotsEngine
	slotsEngine.Init(slotsArray, slotsRefreshArray) # nr of refreshes before result, purely visual
	
	UpdateBet(5)
	UpdateTotal(PlayerData.money) # total money


func _on_raise_pressed() -> void:
	if moneyToBet < 100:
		UpdateBet(moneyToBet + 5)

func _on_lower_pressed() -> void:
	if moneyToBet > 5:
		UpdateBet(moneyToBet - 5)

func _on_play_pressed() -> void:
	if moneyToBet <= totalMoney:
		UpdateTotal(totalMoney - moneyToBet)
		slotsEngine.ResetSlots(slotsRefreshArray)
		slotsEngine.UpdateState(1)
