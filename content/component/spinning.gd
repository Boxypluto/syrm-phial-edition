extends Node3D
class_name Spinning

@export var speed: float = 2.0
@export var axis: Vector3 = Vector3.UP

func _process(delta: float) -> void:
	rotate(axis, speed * delta)
