extends Node3D

var inital_angle: float = rotation.x
@export var pulse_angle: float = deg_to_rad(-45)
var return_factor: float = 0.02

func _ready() -> void:
	print(inital_angle)
	Rhythm.beats(1).connect(func(_a): pulse())

func _physics_process(delta: float) -> void:
	rotation.x = lerp_angle(rotation.x, inital_angle, 1 - return_factor ** delta)

func pulse():
	rotation.x = pulse_angle
