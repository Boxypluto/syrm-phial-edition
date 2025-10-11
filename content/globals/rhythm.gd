@tool
extends RhythmNotifier

var input_latency: float = 0.0

const STAR_STAR = preload("uid://ndtb3dxwabxb")
const STRATASPHERE = preload("uid://dk2oc0w5v7mcx")
const BEYOND_THE_PEDALS = preload("uid://dw4yxu1063bvm")
const PEDALS_IN_BEAMLIGHT = preload("uid://cw026kl2enlfk")
const DESERT_2 = preload("uid://dwyiy863eov7m")
const DESERT_3 = preload("uid://blruphxhocunh")
const ETERNAL_SUNSTORM = preload("uid://brwmmu6uuw578")

static func offet_scale_octave(pitch_scale: float, octave_offset: int) -> float:
	return pitch_scale * (2.0 ** octave_offset)

func get_decimal_beat() -> float:
	return current_position / beat_length

func _ready():
	super._ready()
	if Engine.is_editor_hint(): return
	audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.bus = "Music"
