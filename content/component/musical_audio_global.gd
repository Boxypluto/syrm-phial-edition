extends AudioStreamPlayer
class_name MusicalAudioGlobal

@export var musical_seqence: String
var sequence: MusicalSeqence

func _ready() -> void:
	sequence = Rhythm.build_sequence(musical_seqence)

func play_musical(beat: int, beat_offset:int = 0, start_order_position: int = 0, split_number: int = 1):
	var scale: float = get_musical_scale(beat * split_number + start_order_position)
	if scale > 0.0:
		pitch_scale = scale
		play()

func get_musical_scale(beat: int) -> float:
	assert(beat >= 0, "Beat cannot be less than 0! Current Beat: " + str(beat))
	var note: Note = sequence.sequence.get(beat % sequence.sequence.size())
	return Rhythm.pitch_scale_from_c(note.note, note.octave)
