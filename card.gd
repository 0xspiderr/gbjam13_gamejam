extends Node2D

var strValue
@export var numValue:int
@onready var valueText: Label = $Value

func Spawn(x,y):
	position.x = x
	position.y = y

func Update(value):
	strValue = value
	
	valueText.text = strValue
	match value:
		"J","K","Q": # face - 10
			numValue = 10
		"lA": # low ace - 1
			numValue = 1
		"hA": # high ace - 11
			numValue = 11
		"": # null
			numValue = 0
		_: # everything else
			numValue = int(strValue)
