extends Node2D

func _ready() -> void:
	var sequence: Seqence = Seqence.build(["A B C 0.5x2[A]"], true)
	print(sequence.tracks[0].visual_notes)
	sequence.tracks[0].note_played.connect(test_note)

func test_note(note_length: float, note_pitch: float, note: Note):
	print(note_length)
