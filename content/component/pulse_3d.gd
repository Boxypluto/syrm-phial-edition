extends Node3D
class_name Pulser3D

@export var auto: bool = true
@export var strength: float = 16
@export var beats: int = 2
@export var shrink_speed: float = 1
var base_scale: Vector3

func _ready() -> void:
	base_scale = scale
	if not auto: return
	Rhythm.beats(beats, true, -beats).connect(func(beat): pulse())

func pulse(beat: float = 0.0):
	scale = base_scale * strength

func _process(delta: float) -> void:
	scale = scale.move_toward(base_scale, delta * shrink_speed)
