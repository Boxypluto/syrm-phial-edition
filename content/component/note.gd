extends Resource
class_name Note

var note: NOTE
var octave: int = 0
var pitch_scale: float:
	get():
		return pitch_scale_from_c(note, octave)

const NOTE_LETTERS: PackedStringArray = ["A", "B", "C", "D", "E", "F", "G", "-"]

func _init(_note: NOTE, _octave: int) -> void:
	note = _note
	octave = _octave

func is_rest() -> bool:
	return note == Rhythm.NOTE.REST

enum NOTE {
	A,
	AS,
	B,
	C,
	CS,
	D,
	DS,
	E,
	F,
	FS,
	G,
	GS,
	REST,
}

static func string_to_note_type(string: String) -> NOTE:
	match string:
		"A": return NOTE.A
		"A#": return NOTE.AS
		"B": return NOTE.B
		"C": return NOTE.C
		"C#": return NOTE.CS
		"D": return NOTE.D
		"D#": return NOTE.DS
		"E": return NOTE.E
		"F": return NOTE.F
		"F#": return NOTE.FS
		"G": return NOTE.G
		"G#": return NOTE.GS
		"-": return NOTE.REST
	assert(false, "String: " + string + " is not a valid note!")
	return NOTE.C

static func pitch_scale_from_c(note: NOTE, octave: int = 0) -> float:
	
	if note == NOTE.REST: return 0.0
	
	const NOTE_UP = 1.0595
	const NOTE_DOWN = 1.0 / NOTE_UP
	
	var octave_convert: float = 2.0 ** octave
	var note_scale: float = 1.0
	
	match note:
		NOTE.A: note_scale = NOTE_DOWN ** 3
		NOTE.AS: note_scale = NOTE_DOWN ** 2
		NOTE.B: note_scale = NOTE_DOWN
		NOTE.C: note_scale = 1.0
		NOTE.CS: note_scale = NOTE_UP
		NOTE.D: note_scale = NOTE_UP ** 2
		NOTE.DS: note_scale = NOTE_UP ** 3
		NOTE.E: note_scale = NOTE_UP ** 4
		NOTE.F: note_scale = NOTE_UP ** 5
		NOTE.FS: note_scale = NOTE_UP ** 6
		NOTE.G: note_scale = NOTE_UP ** 7
		NOTE.GS: note_scale = NOTE_UP ** 8
	
	return note_scale * octave_convert

static func build(note_string: String) -> Note:
	assert(note_string.substr(0, 1) in NOTE_LETTERS, "Instruction: \"" + note_string + "\" does not start with a Note Letter! Must be in: " + str(NOTE_LETTERS))
	
	if note_string.length() == 1:
		return Note.new(string_to_note_type(note_string), 0)
	if note_string.length() == 2 and note_string.substr(1, 1) == "#":
		return Note.new(string_to_note_type(note_string), 0)
		
	var sharp_offset: int = 0
	if note_string.substr(1, 1) == "#": sharp_offset = 1
	
	assert(note_string.substr(1 + sharp_offset).is_valid_int(), "The octave of: " + note_string + " is not an integer!")
	var octave: int = note_string.substr(1 + sharp_offset).to_int()
	return Note.new(string_to_note_type(note_string.substr(0, 1 + sharp_offset)), octave)
