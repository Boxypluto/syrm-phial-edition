extends Node
class_name BeatRepeater

@export var music_beat: float = 1.0

signal do_beat(beat: float)

func _ready() -> void:
	Rhythm.beats(music_beat).connect(func(beat): do_beat.emit(beat))
