extends Node2D

@export var rotateSpeed:float = 1
@export var isSpinning:bool = false
@onready var collision_points: Node2D = $CollisionPoints


func _ready() -> void:
	ToggleCollisionPoints()

func ToggleCollisionPoints():
	for child in collision_points.get_children():
		child.visible = !child.visible

func Spin(speed):
	ToggleCollisionPoints()
	rotateSpeed = speed
	isSpinning = true

func _physics_process(delta: float) -> void:
	rotate(rotateSpeed * delta)
	if isSpinning:
		rotateSpeed -= delta


func _on_arrow_stop(col) -> void:
	rotateSpeed = 0
	ToggleCollisionPoints()
	isSpinning = false
