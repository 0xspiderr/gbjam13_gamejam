extends Node2D

@onready var sprite: Sprite2D = $Sprite
@export var value:int
@export var frameIndex:int

func Update(new):
	frameIndex = new
	sprite.frame = frameIndex
	match frameIndex:
		0,1: # null / broken mirror
			value = 0
		2,3: # fruit
			value = 1
		4: # bar
			value = 2
		5: # bell
			value = 3
		6: # four leaf clover
			value = 4
		7: # lucky seven
			value = 7
