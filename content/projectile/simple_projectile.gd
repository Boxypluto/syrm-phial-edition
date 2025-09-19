extends CharacterBody3D
class_name ProjectileSimple

@export var speed: float = 1.0
@export var direction: Vector3

func _physics_process(delta: float) -> void:
	velocity = speed * direction
	
	var collision: KinematicCollision3D = move_and_collide(velocity * delta)
	
	if collision:
		queue_free()
