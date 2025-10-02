extends Sprite3D
class_name Beam

func _ready() -> void:
	Rhythm.beats(1).connect(func(_b): pulse())

func _process(delta: float) -> void:
	var last_rotation: Vector3 = rotation
	look_at(Game.PLAYER.camera.global_position)
	rotation.x = last_rotation.x
	rotation.z = last_rotation.z
	scale.x = move_toward(scale.x, 1.0, delta)

func pulse():
	scale.x = 0.5
