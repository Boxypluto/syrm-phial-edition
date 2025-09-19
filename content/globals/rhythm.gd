extends RhythmNotifier

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

const STAR_STAR = preload("uid://ndtb3dxwabxb")
const STRATASPHERE = preload("uid://dk2oc0w5v7mcx")

static func string_to_note(string: String) -> NOTE:
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

static func build_sequence(seqence_string: String):
	
	const NOTE_LETTERS: PackedStringArray = ["A", "B", "C", "D", "E", "F", "G", "-"]
	
	var instructions: PackedStringArray = seqence_string.split(" ")
	var sequence: MusicalSeqence = MusicalSeqence.new()
	
	for instruction: String in instructions:
		assert(instruction.substr(0, 1) in NOTE_LETTERS, "Instruction: \"" + instruction + "\" does not start with a Note Letter! Must be in: " + str(NOTE_LETTERS))
		
		if instruction.length() == 1:
			sequence.add_note(Note.new(string_to_note(instruction), 0, 1))
			continue
		if instruction.length() == 2 and instruction.substr(1, 1) == "#":
			sequence.add_note(Note.new(string_to_note(instruction), 0, 1))
			continue
			
		var sharp_offset: int = 0
		if instruction.substr(1, 1) == "#": sharp_offset = 1
		
		assert(instruction.substr(1 + sharp_offset).is_valid_int(), "The octave of: " + instruction + " is not an integer!")
		var octave: int = instruction.substr(1 + sharp_offset).to_int()
		sequence.add_note(Note.new(string_to_note(instruction.substr(0, 1 + sharp_offset)), octave, 1))

	return sequence

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

static func offet_scale_octave(pitch_scale: float, octave_offset: int) -> float:
	return pitch_scale * (2.0 ** octave_offset)

func _ready():
	audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.stream = STRATASPHERE
	audio_stream_player.bus = "Music"
	bpm = 91
	audio_stream_player.play()
