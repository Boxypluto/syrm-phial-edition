extends AudioStreamPlayer3D
class_name MusicalAudio3D

func play_note(note: Note):
	var scale: float = note.pitch_scale
	if scale > 0.0:
		pitch_scale = scale
		play()
