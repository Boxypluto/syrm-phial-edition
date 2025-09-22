extends Resource
class_name MusicalSeqence

var sequence_string: String = ""
@export var sequence: Array[Note]
@export var base_beat: float = 1.0

func _init() -> void:
	pass
	
func add_note(note: Note):
	sequence.append(note)

func get_current_note(current_beat: float):
	return sequence.get(int(fmod(current_beat / base_beat, sequence.size())))

static func build(seqence_string: String, base_beat: float = 1.0) -> MusicalSeqence:
	var instructions: PackedStringArray = seqence_string.split(" ")
	var sequence: MusicalSeqence = MusicalSeqence.new()
	sequence.base_beat = base_beat
	for instruction: String in instructions:
		sequence.add_note(Note.build(instruction))
	return sequence
