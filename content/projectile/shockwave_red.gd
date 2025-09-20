extends Node3D
class_name ShockwaveRed

@onready var scaler: Node3D = $Scaler
@onready var sprite: Sprite3D = $Scaler/Sprite
@onready var collision_shape: CollisionShape3D = $Scaler/Hurter/CollisionShape

@export var alpha_curve: Curve

var target_scale: float = 8.0
var expand_speed: float = 12.0
var no_hurt_point: float = 0.7

func _physics_process(delta: float) -> void:
	
	scale.x = move_toward(scale.x, target_scale, expand_speed * delta)
	scale.z = move_toward(scale.z, target_scale, expand_speed * delta)
	
	var progress: float = (scale.x / target_scale)
	
	assert(alpha_curve != null, "Shockwave Red's Alpha Curve is not set up (null)!")
	sprite.modulate.a = alpha_curve.sample_baked(progress)
	
	if not collision_shape.disabled and progress > no_hurt_point:
		collision_shape.disabled = true
	
	
	if scale.x == target_scale:
		queue_free()
