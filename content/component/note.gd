extends Resource
class_name Note

var note: Rhythm.NOTE
var octave: int = 0
var length_in_beats: float

func _init(_note: Rhythm.NOTE, _octave: int, _length_in_beats: float) -> void:
	note = _note
	octave = _octave
	length_in_beats = _length_in_beats

func is_rest() -> bool:
	return note == Rhythm.NOTE.REST
