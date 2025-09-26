extends AudioStreamPlayer
class_name MusicalAudioGlobal

func play_note(note: Note):
	var scale: float = note.pitch_scale
	if scale > 0.0:
		pitch_scale = scale
		play()
