extends Node2D

var strValue
@export var numValue:int
@onready var valueText: Label = $Value

func Update(value, x, y):
	position.x = x
	position.y = y
	
	valueText.text = value
	match value:
		"J","K","Q": # face - 10
			numValue = 10
		"lA": # low ace - 1
			numValue = 1
		"hA": # high ace - 11
			numValue = 11
		_: # everything else
			numValue = int(strValue)
