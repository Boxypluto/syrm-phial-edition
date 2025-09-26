extends Resource
class_name Note

var in_octave_scaling: float = 1.0
var octave: int = 0
var pitch_scale: float:
	get():
		return in_octave_scaling * (2.0 ** octave)

const NOTE_LETTERS: PackedStringArray = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]

## This show ussualy only be used internally in the Note class, or when making custom Note stuff
func _init(_in_octave_scaling, _octave: int) -> void:
	in_octave_scaling = _in_octave_scaling
	octave = _octave

static func letter_to_scaling(note_letter: String):
	assert(note_letter in NOTE_LETTERS, "The note letter must be: " + str(NOTE_LETTERS) + " ONLY! The passed string was: " + note_letter)
	
	const NOTE_CONVERSION = 1.0595
	
	var scaling_operand: int = -3
	
	for letter in NOTE_LETTERS:
		if note_letter == letter:
			return NOTE_CONVERSION ** scaling_operand
		scaling_operand += 1
	
	assert(false, "The note letter must be: A, B, C, D, E, F, or G ONLY! The passed string was: " + note_letter)

static func build(note_string: String) -> Note:
	assert(note_string.substr(0, 1) in NOTE_LETTERS, "Instruction: \"" + note_string + "\" does not start with a Note Letter! Must be in: " + str(NOTE_LETTERS))
	
	if note_string.length() == 1:
		return Note.new(letter_to_scaling(note_string), 0)
	if note_string.length() == 2 and note_string.substr(1, 1) == "#":
		return Note.new(letter_to_scaling(note_string), 0)
		
	var sharp_offset: int = 0
	if note_string.substr(1, 1) == "#": sharp_offset = 1
	
	assert(note_string.substr(1 + sharp_offset).is_valid_int(), "The octave of: " + note_string + " is not an integer!")
	var octave: int = note_string.substr(1 + sharp_offset).to_int()
	return Note.new(letter_to_scaling(note_string.substr(0, 1 + sharp_offset)), octave)
