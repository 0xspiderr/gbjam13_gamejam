extends Node2D

@export var numValue:int
@onready var base: Sprite2D = $Base

func Spawn(x,y):
	position.x = x
	position.y = y

func Update(value):
	base.frame = value
	
	if value != 52:
		match value % 13:
			10,11,12: # face - 10
				numValue = 10
			_: # everything else (ace is calculated separately)
				numValue = value % 13 + 1

func SetAce(value): # 0 -> 1 value ace, 1 -> 11 value ace
	numValue = 1 + 10 * value 

func SetPlusFour(pointsToBlackjack):
	numValue = pointsToBlackjack
	base.frame = 52
