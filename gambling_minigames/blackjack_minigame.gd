extends Node2D

@export var luck:int

var totalMoney
var totalMoneyText
var moneyToBet
var moneyToBetText
var pointsText

var preGame
var midGame
var tryAgain
var gameStatus
var cooldownTimer
var blackjackEngine

func _ready() -> void:
	#init
	preGame = $PreGame
	midGame = $MidGame
	totalMoneyText = $PreGame/BetPanel/Total/Value
	moneyToBetText = $PreGame/BetPanel/Bet/Value
	tryAgain = $MidGame/TryAgain
	gameStatus = $MidGame/GameStatus
	cooldownTimer = $CooldownTimer
	blackjackEngine = $BlackJack
	
	UpdateBet(5)
	UpdateTotal(PlayerData.money) # total money

func UpdateBet(new):
	moneyToBet = new
	moneyToBetText.text = str(moneyToBet)

func UpdateTotal(new):
	totalMoney = new
	PlayerData.money = totalMoney
	totalMoneyText.text = str(totalMoney)


# change scene
func _on_prev_pressed() -> void:
	PlayerData.money = totalMoney
	get_tree().change_scene_to_file("res://gambling_minigames/roulette_minigame.tscn")

func _on_next_pressed() -> void:
	PlayerData.money = totalMoney
	get_tree().change_scene_to_file("res://gambling_minigames/slots_minigame.tscn")



func _on_raise_pressed() -> void:
	if moneyToBet < 100:
		UpdateBet(moneyToBet + 5)

func _on_lower_pressed() -> void:
	if moneyToBet > 5:
		UpdateBet(moneyToBet - 5)


func _on_play_pressed() -> void:
	if moneyToBet <= totalMoney:
		UpdateTotal(totalMoney - moneyToBet)
		preGame.visible = false
		midGame.visible = true
		blackjackEngine.UpdateState(1)
		# deal two cards
		if blackjackEngine.state == 1:
			blackjackEngine.DealCard(32 * blackjackEngine.playerCardList.size() + 17, 80) 
		if blackjackEngine.state == 1: # in case of +4 on first card
			blackjackEngine.DealCard(32 * blackjackEngine.playerCardList.size() + 17, 80)

func _on_try_again_pressed() -> void:
	tryAgain.disabled = true
	midGame.visible = false
	preGame.visible = true
	blackjackEngine.RefreshBoard()


func _on_hit_pressed() -> void:
	if blackjackEngine.playerCardList.size() < blackjackEngine.maxHandSize:
		blackjackEngine.DealCard(32 * blackjackEngine.playerCardList.size() + 17, 80) 

func _on_stand_pressed() -> void:
	blackjackEngine.UpdateState(2) # skip to dealer

func _on_cooldown_timer_timeout() -> void:
	if blackjackEngine.state == 2:
		blackjackEngine.DealCard(32 * blackjackEngine.dealerCardList.size() + 17, 40)
		cooldownTimer.start()


func _on_state_changed() -> void:
	match blackjackEngine.state:
		1:
			gameStatus.text = "YOUR TURN"
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = false
			playButtons.find_child("Stand").disabled = false
			tryAgain.disabled = true
		2:
			gameStatus.text = "DEALER'S TURN"
			cooldownTimer.start()
		3:
			gameStatus.text = "WIN"
			UpdateTotal(totalMoney + 5 * moneyToBet)
			tryAgain.disabled = false
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = true
			playButtons.find_child("Stand").disabled = true
			tryAgain.disabled = false
		4:
			gameStatus.text = "DEALER WIN"
			tryAgain.disabled = false
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = true
			playButtons.find_child("Stand").disabled = true
			tryAgain.disabled = false
		5:
			gameStatus.text = "BUST"
			tryAgain.disabled = false
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = true
			playButtons.find_child("Stand").disabled = true
			tryAgain.disabled = false
		6:
			gameStatus.text = "DEALER BUST"
			UpdateTotal(totalMoney + 5 * moneyToBet)
			tryAgain.disabled = false
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = true
			playButtons.find_child("Stand").disabled = true
			tryAgain.disabled = false
