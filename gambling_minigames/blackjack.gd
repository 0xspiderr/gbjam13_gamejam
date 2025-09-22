extends Node2D

enum gameState {PAUSED = 0, YOUR_TURN = 1, DEALERS_TURN = 2, WIN = 3, DEALER_WIN = 4, BUST = 5, DEALER_BUST = 6}
@export var state: gameState
@export var maxHandSize:int

signal state_changed
@export var playerCardList = Array()
@export var dealerCardList = Array()

@onready var dealer_luck:float = 3.0

func DealCard(x, y):
	SoundManager.play_new_sfx(SoundManager.FLIP_CARD)
	var card = load("res://gambling_minigames/card.tscn").instantiate()
	add_child(card)
	card.Spawn(x,y)
	match state:
		1:
			var type = CalcCardType(PlayerData.luck)
			if type == 52: # +4 - instant win
				card.SetPlusFour(21 - CalcTotalPoints(playerCardList))
			else: # not +4
				card.Update(type)
				if type % 13 == 0:
					card.SetAce(CalcAceValue())
			playerCardList.append(card)
			# check match conditions
			if CalcTotalPoints(playerCardList) > 21: # bust
				UpdateState(5)
			elif CalcTotalPoints(playerCardList) == 21: # blackjack
				UpdateState(3)
			elif playerCardList.size() == maxHandSize: # max hand size, goes to dealer's turn
				UpdateState(2)
		2:
			card.Update(CalcCardType(dealer_luck))
			dealerCardList.append(card)
			# check match conditions
			if CalcTotalPoints(dealerCardList) > 21: # bust
				UpdateState(6)
			elif CalcTotalPoints(dealerCardList) == 21: # blackjack
				UpdateState(4)
			elif CalcTotalPoints(dealerCardList) >= CalcTotalPoints(playerCardList): # compares hands just cause
				UpdateState(4)
			elif dealerCardList.size() == maxHandSize: # max hand size, hands compared - dealer loss
				UpdateState(3)

func CalcAceValue():
	var total
	var value
	match state:
		1: # player turn
			total = CalcTotalPoints(playerCardList)
		2: # dealer turn
			total = CalcTotalPoints(dealerCardList)
	if total <= 6:
		value = 1
	else: 
		value = 0
	return value


func ConvertTypeToNumValue(type): # converts card type to its numeric value acoording to blackjack rules
	var num
	match type:
		0:
			num = CalcAceValue()
		10,11,12:
			num = 10
		_:
			num = int(type)
	return int(num) 

func ConvertNumValueToType(num): # reverse of above function
	var type
	match num: # special card situations
		1,11: # ace
			type = 0
		10: # face cards
			type = randi_range(10,12)
		_:
			type = int(num)
	return int(type)

func CalcCardType(luck): # calculates card based on the player/dealer's current hand and luck
	var cardType
	var plusFourRoll = randf_range(0,1000)
	if plusFourRoll < 1 + 0.2 * luck:
		cardType = 52 # +4 frame
	else:
		var pointsToBlackjack
		match state:
			1:
				pointsToBlackjack = 21 - CalcTotalPoints(playerCardList)
			2:
				pointsToBlackjack = 21 - CalcTotalPoints(dealerCardList)
		var suit = randi_range(0,3)
		var luckRoll = randf_range(0,100)
		if luckRoll < (float(100 / 13) + 2.5 * luck) and pointsToBlackjack <= 11: # exact number for blackjack
			cardType = suit * 13 + ConvertNumValueToType(pointsToBlackjack)
		elif luckRoll >= (float(100 / 13) + 2.5 * luck): # literally any card except for the one you need
			var number = randi_range(0,12)
			while ConvertTypeToNumValue(number) == pointsToBlackjack:
				number = randi_range(0,12)
			cardType = suit * 13 + number
		else: # regular roll
			cardType = suit * 13 + randi_range(0,12)
	return int(cardType)

func CalcTotalPoints(array):
	var total = 0
	for card in array:
		total += card.numValue
	return total

func UpdateState(new):
	state = new
	emit_signal("state_changed")

func RefreshBoard():
	for card in playerCardList:
		remove_child(card)
	for card in dealerCardList:
		remove_child(card)
	playerCardList.clear()
	dealerCardList.clear()
