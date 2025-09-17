extends Node2D

@export var rotateSpeed:float = 1
@onready var collision_points: Node2D = $CollisionPoints


func _ready() -> void:
	ToggleCollisionPoints()

func ToggleCollisionPoints():
	for child in collision_points.get_children():
		child.visible = !child.visible

func Spin(speed):
	ToggleCollisionPoints()
	rotateSpeed = speed

func _physics_process(delta: float) -> void:
	rotate(rotateSpeed * delta)


func _on_arrow_slow_down(delta: Variant) -> void:
	if rotateSpeed > 0:
		rotateSpeed -= delta
	else:
		rotateSpeed = 0
