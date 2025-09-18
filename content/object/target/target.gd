extends Node3D

var rotation_velocity: float = 10.0
var rotation_damping: float = 0.5

@onready var target_spinner: Sprite3D = $TargetSpinner

func on_hit() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	rotation_velocity = 50.0
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT

func _physics_process(delta: float) -> void:
	target_spinner.rotation.y += rotation_velocity * delta
	rotation_velocity *= pow(rotation_damping, delta)
