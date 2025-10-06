extends CharacterBody3D
class_name ProjectileSimple

var speed: float
@export var direction: Vector3
@export var spawn_time: float

func _init() -> void:
	spawn_time = Time.get_ticks_msec()

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision3D = move_and_collide(speed * direction * delta)
	
	if collision or Time.get_ticks_msec() - spawn_time > 20.0 * 1000.0:
		queue_free()
