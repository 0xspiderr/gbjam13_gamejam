extends Node2D

@export var luck:int

var totalMoney
var totalMoneyText
var moneyToBet
var moneyToBetText
enum gameState {PAUSED = 0, YOUR_TURN = 1, DEALERS_TURN = 2, WIN = 3, DEALER_WIN = 4, BUST = 5, DEALER_BUST = 6}
var state: gameState

var preGame
var midGame
var tryAgain
var gameStatus
var cooldownTimer

var cardTypes = ["1","2","3","4","5","6","7","8","9","10","J","K","Q","lA","hA"]
var playerCardList = Array()
var dealerCardList = Array()

func _ready() -> void:
	#init
	preGame = $PreGame
	midGame = $MidGame
	totalMoneyText = $PreGame/BetPanel/Total/Value
	moneyToBetText = $PreGame/BetPanel/Bet/Value
	tryAgain = $MidGame/TryAgain
	gameStatus = $MidGame/GameStatus
	cooldownTimer = $CooldownTimer
	
	UpdateBet(5)
	UpdateTotal(int(FileAccess.open("res://data.txt", FileAccess.READ).get_line())) # total money

func UpdateBet(new):
	moneyToBet = new
	moneyToBetText.text = str(moneyToBet)

func UpdateTotal(new):
	totalMoney = new
	totalMoneyText.text = str(totalMoney)

"""
func DealCard():
	var card = load("res://card.tscn").instantiate()
	add_child(card)
	# player
	if state == 1:
		var x
		if playerCardList.size() == 0:
			x = 15
		else:
			x = playerCardList.size() * 20 + 15
		card.Update(cardTypes[randi_range(0,cardTypes.size() - 1)], x, 80)
		playerCardList.append(card)
		var total = CalcTotalPoints(playerCardList)
		if total == 21:
			UpdateState(4)
		elif total > 21:
			UpdateState(3)
		elif total < 21 and playerCardList.size() == 7:
			UpdateState(3)
	# dealer
	elif state == 3:
		var x
		if dealerCardList.size() == 0:
			x = 15
		else:
			x = dealerCardList.size() * 20 + 15
		card.Update(cardTypes[randi_range(0,cardTypes.size())], x, 50)
		dealerCardList.append(card)
		var total = CalcTotalPoints(dealerCardList)
		if total == 21:
			UpdateState(4)
		elif total > 21:
			UpdateState(6)
		elif total > CalcTotalPoints(playerCardList) and dealerCardList.size() == 7:
			UpdateState(4)
		else:
			UpdateState(3)
"""

func DealCard():
	var card = load("res://card.tscn").instantiate()
	add_child(card)
	var x
	if playerCardList.size() == 0:
		x = 15
	else:
		x = playerCardList.size() * 20 + 15
	card.Spawn(x,80)
	card.Update(cardTypes[randi_range(0,cardTypes.size() - 1)])
	playerCardList.append(card)
	var total = CalcTotalPoints(playerCardList)
	if total == 21:
		UpdateState(3)
	elif total > 21:
		UpdateState(5)
	elif total < 21 and playerCardList.size() == 7:
		UpdateState(3)

func CalcTotalPoints(array):
	var total = 0
	for card in array:
		total += card.numValue
	return total

# change scene
func _on_prev_pressed() -> void:
	var file = FileAccess.open("res://data.txt", FileAccess.WRITE)
	file.store_line(str(totalMoney))
	get_tree().change_scene_to_file("res://gambling_minigames/roulette_minigame.tscn")

func _on_next_pressed() -> void:
	var file = FileAccess.open("res://data.txt", FileAccess.WRITE)
	file.store_line(str(totalMoney))
	get_tree().change_scene_to_file("res://gambling_minigames/slots_minigame.tscn")

func UpdateState(new):
	state = new
	match state:
		1:
			gameStatus.text = "YOUR TURN"
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = false
			playButtons.find_child("Stand").disabled = false
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
		4:
			gameStatus.text = "DEALER WIN"
			tryAgain.disabled = false
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = true
			playButtons.find_child("Stand").disabled = true
		5:
			gameStatus.text = "BUST"
			tryAgain.disabled = false
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = true
			playButtons.find_child("Stand").disabled = true
		6:
			gameStatus.text = "DEALER BUST"
			UpdateTotal(totalMoney + 5 * moneyToBet)
			tryAgain.disabled = false
			var playButtons = midGame.find_child("PlayButtons")
			playButtons.find_child("Hit").disabled = true
			playButtons.find_child("Stand").disabled = true

func _on_raise_pressed() -> void:
	if moneyToBet < 100:
		UpdateBet(moneyToBet + 5)

func _on_lower_pressed() -> void:
	if moneyToBet > 5:
		UpdateBet(moneyToBet - 5)


func _on_play_pressed() -> void:
	UpdateTotal(totalMoney - moneyToBet)
	preGame.visible = false
	midGame.visible = true
	UpdateState(1)
	DealCard(); DealCard()

func _on_try_again_pressed() -> void:
	tryAgain.disabled = true
	midGame.visible = false
	preGame.visible = true
	state = 0
	for card in playerCardList:
		remove_child(card)
	for card in dealerCardList:
		remove_child(card)
	playerCardList.clear()
	dealerCardList.clear()


func _on_hit_pressed() -> void:
	if playerCardList.size() < 7:
		DealCard()

func _on_stand_pressed() -> void:
	UpdateState(5) # temp

func _on_cooldown_timer_timeout() -> void:
	DealCard()
	cooldownTimer.start()
