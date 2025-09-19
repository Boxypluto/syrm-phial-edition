extends Node

@export var to_fade: Node
@export var auto: bool = true
@export var fade_beat: float = 1.0
@export var sync_fade: bool = true
@export var fade_speed: float = 1.0

func _ready() -> void:
	if not auto: return
	Rhythm.beats(fade_beat, true, -fade_beat).connect(do_fade)

func do_fade(beat: float):
	assert(to_fade.modulate != null, "Node in BeatFader Must have a Modulate Property!")
	to_fade.modulate.a = 1.0

func _process(delta: float) -> void:
	assert(to_fade.modulate != null, "Node in BeatFader Must have a Modulate Property!")
	if to_fade.modulate.a == 0.0: return
	to_fade.modulate.a -= delta * fade_speed * (Rhythm.beat_length if sync_fade else 1)
	if to_fade.modulate.a < 0.0: to_fade.modulate.a = 0.0
