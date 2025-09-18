extends Node2D

var totalMoney
var totalMoneyText
var moneyToBet
var moneyToBetText
var playButton
var betAdjust
var blackButton
var pinkButton
var rouletteEngine
var gameStatus

func UpdateBet(new):
	moneyToBet = new
	moneyToBetText.text = str(moneyToBet)

func UpdateTotal(new):
	totalMoney = new
	PlayerData.money = totalMoney
	totalMoneyText.text = str(totalMoney)

func _ready() -> void:
	totalMoneyText = $BetPanel/Total/Value
	moneyToBetText = $BetPanel/Bet/Value
	playButton = $PlayButtons/Play
	betAdjust = $PlayButtons/BetAdjust
	blackButton = $BetOn/Black
	pinkButton = $BetOn/Pink
	rouletteEngine = $RouletteEngine
	gameStatus = $Status
	
	UpdateBet(5)
	UpdateTotal(PlayerData.money)
	rouletteEngine.Init($Roulette, $Arrow)


func _on_play_pressed() -> void:
	if moneyToBet <= totalMoney:
		UpdateTotal(totalMoney - moneyToBet)
		rouletteEngine.UpdateState(1)


func _on_raise_pressed() -> void:
	if moneyToBet < 100:
		UpdateBet(moneyToBet + 5)


func _on_lower_pressed() -> void:
	if moneyToBet > 5:
		UpdateBet(moneyToBet - 5)


func _on_toggle_color() -> void:
	pass # Replace with function body.


func _on_state_changed() -> void:
	match rouletteEngine.state:
		1:
			gameStatus.text = ""
			blackButton.disabled = true
			pinkButton.disabled = true
			playButton.disabled = true
			betAdjust.visible = false
		2:
			UpdateTotal(totalMoney + 8 * moneyToBet)
			gameStatus.text = "YOU WIN!"
			blackButton.disabled = false
			pinkButton.disabled = false
			playButton.disabled = false
			betAdjust.visible = true
		3:
			gameStatus.text = "WOMP WOMP"
			blackButton.disabled = false
			pinkButton.disabled = false
			playButton.disabled = false
			betAdjust.visible = true


func _on_black_pressed() -> void:
	rouletteEngine.ToggleColor()
	pinkButton.disabled = false
	blackButton.disabled = true


func _on_pink_pressed() -> void:
	rouletteEngine.ToggleColor()
	pinkButton.disabled = true
	blackButton.disabled = false
