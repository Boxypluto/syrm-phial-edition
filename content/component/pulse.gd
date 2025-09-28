extends Node2D
class_name Pulser

@export var strength: float = 16
@export var beats: int = 2
@export var shrink_speed: float = 1
@export var on_beat: bool = true
var base_scale: Vector2

func _ready() -> void:
	base_scale = scale
	if not on_beat: return
	Rhythm.beats(beats, true, -beats).connect(func(beat): pulse())

func pulse():
	scale = base_scale * strength

func _process(delta: float) -> void:
	scale = scale.move_toward(base_scale, delta * shrink_speed)
