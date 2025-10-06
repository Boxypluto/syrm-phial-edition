extends Sprite3D

@export var rotation_target: Node3D

func _process(delta: float) -> void:
	global_rotation.y = rotation_target.global_rotation.y
