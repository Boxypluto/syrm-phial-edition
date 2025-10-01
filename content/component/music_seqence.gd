extends Resource
class_name Seqence

@export var sequence_strings: Array[String]
@export var exported_include_signal: bool = false

const NOTES_AND_PATTERNS_REGEX = "(?:(?<pattern_multiplier>(?:\\d+\\.?\\d*|\\.\\d+))x)?(?<pattern_repitition>\\d+)?(?:\\[(?<pattern>(?:[^][]*|(?R))*)\\])(?<pattern_octave>(?:-(?=\\d))?\\d+)?|(?<note>(?<note_length>(?:\\d+\\.?\\d*|\\.\\d+))?(?<note_pitch>[A-G](?:(?<=[ACDFG])#)?)(?<note_octave>(?:-(?=\\d))?\\d+)?)|(?<rest_length>(?:\\d+\\.?\\d*|\\.\\d+))?(?<rest>-)"
const TRIM_EXTRA_SPACE_REGEX = "(?<= )\\s+|\\v+|( +$)|(^ +)"
const MULTIPLIER_REGEX: String = "(?:^X(?<multiplier>\\d+\\.?\\d*|\\.\\d+))"

static var patterns_and_notes: RegEx = RegEx.create_from_string(NOTES_AND_PATTERNS_REGEX)
static var trimmed: RegEx = RegEx.create_from_string(TRIM_EXTRA_SPACE_REGEX)
static var multiplier: RegEx = RegEx.create_from_string(MULTIPLIER_REGEX)

var tracks_count: int
var tracks: Array[Track]
var length: float

class NoteInfo:
	var note_distance: float
	var note_pitch_scale: float
	var note: Note
	var note_index: int
	var note_length: float
	var distance_to_next: float

func setup_exported() -> void:
	if sequence_strings == []: return
	build(sequence_strings, exported_include_signal, self)

func next(current_beat: float, track_index: int = 0) -> NoteInfo:
	var beat: float = fmod(current_beat, length)
	var current_pattern_start: float = current_beat - beat
	var track: Track = tracks[track_index]
	var index: int = 0
	
	var wrapped_offset: float = 0.0
	for note_beat: float in track.note_start_beats:
		if note_beat > beat:
			break
		index += 1
	
	if index >= track.note_start_beats.size():
		index = 0
		var last_index: int = track.note_start_beats.size() - 1
		wrapped_offset = track.note_start_beats[last_index] + track.note_distance_to_next_note[last_index]
	
	var info: NoteInfo = NoteInfo.new()
	info.note_distance = (current_pattern_start + track.note_start_beats[index] - current_beat + wrapped_offset)
	info.note_pitch_scale = track.notes[index].pitch_scale
	info.note = track.notes[index]
	info.note_index = index
	info.note_length = track.note_lengths[index]
	info.distance_to_next = track.note_distance_to_next_note[index]
	return info

func next_positions(current_beat: float, beat_range_end: float, track_index: int = 0) -> Array[float]:
	var beat: float = fmod(current_beat, length)
	var current_pattern_start: float = current_beat - beat
	var track: Track = tracks[track_index]
	
	var first: NoteInfo = next(current_beat, track_index)
	var index: int = first.note_index
	var current_distance_from_first: float = 0.0
	
	var positions: Array[float] = [current_beat + first.note_distance]
	while(current_distance_from_first <= beat_range_end):
		var current_search_start: float = current_beat + first.note_distance + current_distance_from_first
		var current: NoteInfo = next(current_search_start)
		positions.append(current_search_start + current.note_distance)
		current_distance_from_first += current.note_length
	
	return positions

static func build(seqences: Array[String], include_signal: bool = false, passed_sequence: Seqence = null) -> Seqence:
	assert(seqences != [], "Cannot build a Sequence from an empty array!")
	var sequence: Seqence
	if passed_sequence != null:
		sequence = passed_sequence
	else:
		sequence = Seqence.new()
	sequence.tracks_count = seqences.size()
	sequence.tracks = []
	var longest_track_length: float = 0.0
	
	for index in range(sequence.tracks_count):
		var track: Track = _build_track(seqences[index])
		sequence.tracks.append(track)
		
		if track.length > longest_track_length:
			longest_track_length = track.length
	
	sequence.length = longest_track_length
	
	if include_signal:
		for track in sequence.tracks:
			track.build_signal(sequence.length)
	
	return sequence

static var example = "[A B]"
static var digits: PackedStringArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

class SequenceTrack:
	var length_multiplier: float = 1.0

static func _build_track(seqence_string: String):
	var multiplier_match: RegExMatch = multiplier.search(seqence_string)
	var multiplier_number: float = multiplier_match.get_string("multiplier").to_float() if multiplier_match != null else 1.0
	var without_multiplier: String = seqence_string.substr(multiplier_match.get_string().length()) if multiplier_match != null else seqence_string
	var cleaned: String = trimmed.sub(without_multiplier, "", true)
	
	return proccess_pattern(cleaned, multiplier_number)

class Track:
	var length: float
	var note_start_beats: Array[float]
	var note_lengths: Array[float]
	var note_distance_to_next_note: Array[float]
	var notes: Array[Note]
	var visual_notes: Array[String] = []
	signal note_played(note_length: float, note_pitch: float, note: Note)
	
	func _init(_current_timestamp: float, _time_stamps: Array[float], _notes: Array[Note]) -> void:
		length = _current_timestamp
		note_start_beats = _time_stamps
		notes = _notes
	
	func build_signal(sequence_length: float):
		for index in range(notes.size()):
			Rhythm.beats(sequence_length, true, note_start_beats[index]).connect(func(beat): note_played.emit(note_lengths[index], notes[index].pitch_scale, notes[index]))

static func proccess_pattern(cleaned_pattern: String, multiplier: float = 1.0, octave_offset: int = 0, data: Track = Track.new(0.0, [], [])) -> Track:
	var notes_and_patterns_matches: Array[RegExMatch] = patterns_and_notes.search_all(cleaned_pattern)
	
	for note_or_pattern in notes_and_patterns_matches:
		
		var is_note: bool = note_or_pattern.get_string("note") != ""
		var is_pattern: bool = note_or_pattern.get_string("pattern") != ""
		var is_rest: bool = note_or_pattern.get_string("rest") != ""
		
		if is_note:
			data.note_start_beats.append(data.length)
			var octave: int = note_or_pattern.get_string("note_octave").to_int()
			var note: Note = Note.build(note_or_pattern.get_string("note_pitch") + str(octave + octave_offset))
			data.notes.append(note)
			var note_length_string: String = note_or_pattern.get_string("note_length")
			var note_length: float = (note_length_string.to_float() if note_length_string != "" else 1.0) * multiplier
			data.note_lengths.append(note_length)
			data.note_distance_to_next_note.append(note_length)
			data.length += note_length
			data.visual_notes.append(note_or_pattern.get_string("note"))
		
		if is_rest:
			var rest_length_string: String = note_or_pattern.get_string("rest_length")
			var rest_length: float = (rest_length_string.to_float() if rest_length_string != "" else 1.0) * multiplier
			data.length += rest_length
			if data.note_distance_to_next_note.is_empty(): data.note_distance_to_next_note = [0.0]
			data.note_distance_to_next_note[data.note_distance_to_next_note.size() - 1] += rest_length
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
