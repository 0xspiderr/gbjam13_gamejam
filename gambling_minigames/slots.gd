extends Node2D

var state
var winMultiplier
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

var slotsArray
var slotsRefreshArray
var currSlotIndex
@onready var timer = $Timer
@onready var chanceArray = [30 - 1 * PlayerData.luck, 20 - 1 * PlayerData.luck, 
					15 - 0.5 * PlayerData.luck, 12 + 0.6 * PlayerData.luck, 9 + 0.6 * PlayerData.luck, 
					9 + 0.6 * PlayerData.luck, 5 + 0.7 * PlayerData.luck]
signal state_changed

func Init(slot_array, refresh_array):
	slotsArray = slot_array
	slotsRefreshArray = refresh_array.duplicate()
	currSlotIndex = 0

func UpdateState(new):
	state = new
	if state == 1:
		timer.start()
	emit_signal("state_changed")

func ResetSlots(array):
	for slot in slotsArray:
		slot.Update(0)
	slotsRefreshArray = array.duplicate()
	currSlotIndex = 0
	winMultiplier = null

func RollSlot():
	audio_stream_player.play()
	if slotsRefreshArray[currSlotIndex] > 0: # cosmetic roll
		var value = randi_range(1,7)
		while value == slotsArray[currSlotIndex].value:
			value = randi_range(1,7)
		slotsArray[currSlotIndex].Update(value)
		slotsRefreshArray[currSlotIndex] -= 1
	else: # actual roll + index advance
		var luckRoll = randf_range(0,100)
		var chance = 0
		for ind in range(chanceArray.size()):
			if luckRoll > chance + chanceArray[ind]:
				chance += chanceArray[ind]
			else:
				slotsArray[currSlotIndex].Update(ind + 1)
				break
		currSlotIndex += 1
		if currSlotIndex > slotsArray.size() - 1:
			CheckSlots()

func CheckSlots():
	for ind1 in range(0, slotsArray.size() - 1):
		for ind2 in range(ind1 + 1, slotsArray.size()):
			if slotsArray[ind1].frameIndex == slotsArray[ind2].frameIndex:
				if winMultiplier == null:
					winMultiplier = 0 # change from null
				winMultiplier += slotsArray[ind1].value
	if winMultiplier != null: # at least 1 combo (yes even the dumbass broken mirror)
		UpdateState(2)
	else:
		UpdateState(3)


func _on_timer_timeout() -> void:
	RollSlot()
	if state == 1:
		timer.start()
