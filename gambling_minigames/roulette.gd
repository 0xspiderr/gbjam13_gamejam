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
	arrow.Init(wheel)

func ToggleColor(col):
	color = col
	emit_signal("toggle_color")

func ReturnToggleColor():
	var col
	if color == 0:
		col = 1
	else:
		col = 0
	return col

func StartSpin():
	var col
	var luckRoll = randf_range(0,100)
	if luckRoll < 15 + 3 * PlayerData.luck:
		col = color
	else:
		col = ReturnToggleColor()
	arrow.SetColorToStop(col)
	print_debug("color to stop on: " + str(col))
	wheel.Spin(10)

func UpdateState(new):
	state = new
	if state == 1:
		StartSpin()
	emit_signal("state_changed")


func _on_arrow_stop(col: Variant) -> void:
	if color == col:
		UpdateState(2)
	else:
		UpdateState(3)
