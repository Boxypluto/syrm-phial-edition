extends Node3D
class_name Level

@export var music: AudioStream
@export var bpm: float = 150.0
@export var bpm_scale: float = 1.0

func _ready() -> void:
	Rhythm.audio_stream_player.stop()
	Rhythm.running = false
	Rhythm.audio_stream_player.stream = music
	Rhythm.bpm = bpm * bpm_scale
	Rhythm.audio_stream_player.play()
