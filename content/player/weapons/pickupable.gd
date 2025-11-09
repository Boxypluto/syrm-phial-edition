extends RigidBody3D
class_name Pickupable

@export var id: StringName

func do_pickup() -> StringName:
	queue_free()
	return id
