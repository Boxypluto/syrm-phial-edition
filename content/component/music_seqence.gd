extends Resource
class_name Seqence

#const PATTERN_REGEX: String = "(?<repitition>\\d*)(?:\\[(?<pattern>(?:[^][]*|(?R))*)\\])"
#const NOTE_REGEX: String = "/(?<note>(?<note_length>(?:\\d+\\.?\\d*|\\.\\d+))?(?<note_pitch>[A-G](?:(?<=[ACDFG])#)?)(?<note_octave>(?:-(?=\\d))?\\d+?)?)|(?<pattern>S)|(?<rest_length>(?:\\d+\\.?\\d*|\\.\\d+))?(?<rest>-)/gm"
const NOTES_AND_PATTERNS_REGEX = "(?:(?<pattern_multiplier>(?:\\d+\\.?\\d*|\\.\\d+))x)?(?<pattern_repitition>\\d+)?(?:\\[(?<pattern>(?:[^][]*|(?R))*)\\])(?<pattern_octave>(?:-(?=\\d))?\\d+)?|(?<note>(?<note_length>(?:\\d+\\.?\\d*|\\.\\d+))?(?<note_pitch>[A-G](?:(?<=[ACDFG])#)?)(?<note_octave>(?:-(?=\\d))?\\d+)?)|(?<rest_length>(?:\\d+\\.?\\d*|\\.\\d+))?(?<rest>-)"
const TRIM_EXTRA_SPACE_REGEX = "(?<= )\\s+|\\v+|( +$)|(^ +)"
const MULTIPLIER_REGEX: String = "(?:^X(?<multiplier>\\d+\\.?\\d*|\\.\\d+))"

#static var patterns: RegEx = RegEx.create_from_string(PATTERN_REGEX)
#static var notes: RegEx = RegEx.create_from_string(NOTE_REGEX)
static var patterns_and_notes: RegEx = RegEx.create_from_string(NOTES_AND_PATTERNS_REGEX)
static var trimmed: RegEx = RegEx.create_from_string(TRIM_EXTRA_SPACE_REGEX)
static var multiplier: RegEx = RegEx.create_from_string(MULTIPLIER_REGEX)

var tracks: int

class Instruction:
	var length: float 
	var note: Note

static func build(seqences: Array[String]):
	var sequence: Seqence = Seqence.new()
	sequence.tracks = seqences.size()

static var example = "/[A B]"
static var digits: PackedStringArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

class SequenceTrack:
	var length_multiplier: float = 1.0
	

static func _build_single(seqence_string: String):
	var multiplier_match: RegExMatch = multiplier.search(seqence_string)
	var multiplier_number: float = multiplier_match.get_string("multiplier").to_float() if multiplier_match != null else 1.0
	var without_multiplier: String = seqence_string.substr(multiplier_match.get_string().length()) if multiplier_match != null else seqence_string
	var cleaned: String = trimmed.sub(without_multiplier, "", true)
	
	var track_data: FullPatternData = proccess_pattern(cleaned, multiplier_number)
	
	print(track_data.visual_notes)

class FullPatternData:
	var current_timestamp: float
	var time_stamps: Array[float]
	var notes: Array[Note]
	var visual_notes: Array[String] = []
	func _init(_current_timestamp: float, _time_stamps: Array[float], _notes: Array[Note]) -> void:
		current_timestamp = _current_timestamp
		time_stamps = _time_stamps
		notes = _notes

static func proccess_pattern(cleaned_pattern: String, multiplier: float = 1.0, octave_offset: int = 0, data: FullPatternData = FullPatternData.new(0.0, [], [])) -> FullPatternData:
	var notes_and_patterns_matches: Array[RegExMatch] = patterns_and_notes.search_all(cleaned_pattern)
	
	for note_or_pattern in notes_and_patterns_matches:
		
		var is_note: bool = note_or_pattern.get_string("note") != ""
		var is_pattern: bool = note_or_pattern.get_string("pattern") != ""
		var is_rest: bool = note_or_pattern.get_string("rest") != ""
		
		if is_note:
			data.time_stamps.append(data.current_timestamp)
			var octave: int = note_or_pattern.get_string("note_octave").to_int()
			var note: Note = Note.build(note_or_pattern.get_string("note_pitch") + str(octave + octave_offset))
			data.notes.append(note)
			var note_length: String = note_or_pattern.get_string("note_length")
			data.current_timestamp += (note_length.to_float() if note_length != "" else 1.0) * multiplier
			data.visual_notes.append(note_or_pattern.get_string("note"))
		
		if is_rest:
			var rest_length: String = note_or_pattern.get_string("rest_length")
			data.current_timestamp += (rest_length.to_float() if rest_length != "" else 1.0) * multiplier
			data.visual_notes.append(note_or_pattern.get_string("rest"))
		
		if is_pattern:
			var sub_pattern: String = note_or_pattern.get_string("pattern")
			var repititions: int = note_or_pattern.get_string("pattern_repitition").to_int()
			if repititions == 0: repititions = 1
			var sub_multiplier: float = note_or_pattern.get_string("pattern_multiplier").to_float()
			if sub_multiplier == 0: sub_multiplier = 1.0
			var octave: int = note_or_pattern.get_string("pattern_octave").to_int()
			for repitition in range(repititions):
				data = proccess_pattern(sub_pattern, sub_multiplier * multiplier, octave_offset + octave, data)
	
	return data
