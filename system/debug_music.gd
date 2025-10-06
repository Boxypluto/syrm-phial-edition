extends Label

func _process(delta: float) -> void:
	text = ""
	if Rhythm.audio_stream_player.playing:
		text = "MUSIC: Eternal Sunstorm (Desert #1)"
	else:
		text = "MUSIC: NONE"
