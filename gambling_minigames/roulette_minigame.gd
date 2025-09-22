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
var currentColor
var buttonList
var currentButton:int

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
	buttonList = [blackButton, pinkButton, playButton, betAdjust.find_child("Raise"), betAdjust.find_child("Lower")]
	currentButton = 0
	currentColor = $BetOn/CurrentColor
	UpdateColorText(0)
	UpdateBet(5)
	UpdateTotal(PlayerData.money)
	rouletteEngine.Init($Roulette, $Arrow)

func UpdateColorText(col):
	match col:
		0:
			currentColor.text = "Color: black"
		1:
			currentColor.text = "Color: pink"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		if currentButton > 0:
			currentButton -= 1
			buttonList[currentButton].grab_focus()
	if Input.is_action_just_pressed("right"):
		if currentButton < buttonList.size() - 1:
			currentButton += 1
			buttonList[currentButton].grab_focus()

func _on_play_pressed() -> void:
	SoundManager.play_new_sfx(SoundManager.CLICK)
	if moneyToBet <= totalMoney:
		UpdateTotal(totalMoney - moneyToBet)
		rouletteEngine.UpdateState(1)


func _on_raise_pressed() -> void:
	SoundManager.play_new_sfx(SoundManager.CLICK)
	if moneyToBet < 100:
		UpdateBet(moneyToBet + 5)


func _on_lower_pressed() -> void:
	SoundManager.play_new_sfx(SoundManager.CLICK)
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
			$SFXCooldown.wait_time = 0.2
			$SFXCooldown.start()
		2:
			$SFXCooldown.stop()
			UpdateTotal(totalMoney + 5 * moneyToBet)
			SoundManager.play_new_sfx(SoundManager.YIPPEE)
			gameStatus.text = "YOU WIN!"
			blackButton.disabled = false
			pinkButton.disabled = false
			playButton.disabled = false
			betAdjust.visible = true
		3:
			$SFXCooldown.stop()
			SoundManager.play_new_sfx(SoundManager.WOMP_WOMP)
			gameStatus.text = "WOMP WOMP"
			blackButton.disabled = false
			pinkButton.disabled = false
			playButton.disabled = false
			betAdjust.visible = true


func _on_black_pressed() -> void:
	SoundManager.play_new_sfx(SoundManager.CLICK)
	rouletteEngine.ToggleColor(0)
	pinkButton.disabled = false
	blackButton.disabled = true
	blackButton.button_pressed = true
	pinkButton.button_pressed = false
	UpdateColorText(0)


func _on_pink_pressed() -> void:
	SoundManager.play_new_sfx(SoundManager.CLICK)
	rouletteEngine.ToggleColor(1)
	pinkButton.disabled = true
	blackButton.disabled = false
	pinkButton.button_pressed = true
	blackButton.button_pressed = false
	UpdateColorText(1)


func _on_sfx_cooldown_timeout() -> void:
	SoundManager.sfx_stream_player.stream = SoundManager.FLIP_CARD
	SoundManager.sfx_stream_player.play()
	$SFXCooldown.wait_time += 0.01
	$SFXCooldown.start()
