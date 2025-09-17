extends Node2D

@export var color:int
var wheel
var arrow

@export var state:int

signal state_changed
signal toggle_color

func Init(roulette_wheel, roulette_arrow):
	color = 0
	wheel = roulette_wheel
	arrow = roulette_arrow

func ToggleColor():
	if color == 0:
		color = 1
	else:
		color = 0
	emit_signal("toggle_color")

func StartSpin():
	var luckRoll = randf_range(0,100)
	if luckRoll < 15 + 5 * PlayerData.luck:
		wheel.Spin(5) # exact speed to land on same color
	else: 
		wheel.Spin(5)

func UpdateState(new):
	state = new
	emit_signal("state_changed")
