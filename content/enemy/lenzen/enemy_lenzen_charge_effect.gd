extends Sprite3D

func _ready() -> void:
	scale = Vector3.ONE * 2.0

func _physics_process(delta: float) -> void:
	if scale == Vector3.ZERO:
		queue_free()
	scale = scale.move_toward(Vector3.ZERO, 0.4)
