extends Node3D

@export var modulate: Sprite3D

func end() -> void:
	queue_free()

func _ready() -> void:
	scale = Vector3.ZERO

func _physics_process(delta: float) -> void:
	scale += Vector3.ONE * delta * 20.0
	if modulate:
		modulate.modulate.a -= delta * 0.05
