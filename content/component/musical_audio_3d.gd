extends AudioStreamPlayer3D
class_name MusicalAudio3D

@export_multiline var musical_seqence: String
@export var base_beat: float = 1.0
var sequence: MusicalSeqence

func _ready() -> void:
	sequence = MusicalSeqence.build(musical_seqence, base_beat)

func play_musical(beat: int, beat_offset:int = 0, start_order_position: int = 0, split_number: int = 1):
	var scale: float = get_musical_scale(beat * split_number + start_order_position)
	if scale > 0.0:
		pitch_scale = scale
		play()

func get_musical_scale(beat: int) -> float:
	assert(beat >= 0, "Beat cannot be less than 0! Current Beat: " + str(beat))
	var note: Note = sequence.get_current_note(beat)
	return note.pitch_scale
