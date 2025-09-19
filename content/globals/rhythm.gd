extends RhythmNotifier

const STAR_STAR = preload("uid://ndtb3dxwabxb")

func _ready():
	audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.stream = STAR_STAR
	bpm = 130
	audio_stream_player.play()
