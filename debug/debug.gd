extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Debug_CaptureMouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("Debug_UncaptureMouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

var flags: Dictionary[String, bool] = {
	"sliz": false,
	"thumper": false,
	"gustbloom": false,
	"lenzen": false,
}

func _process(delta: float) -> void:
	var mode: bool = Input.is_key_pressed(KEY_ALT)
	if Input.is_key_pressed(KEY_1):
		flags.set("sliz", mode)
	if Input.is_key_pressed(KEY_2):
		flags.set("thumper", mode)
	if Input.is_key_pressed(KEY_3):
		flags.set("gustbloom", mode)
	if Input.is_key_pressed(KEY_4):
		flags.set("lenzen", mode)
	if Input.is_key_pressed(KEY_MINUS):
		match mode:
			true:
				if not Rhythm.audio_stream_player.playing:
					Rhythm.audio_stream_player.play(0.0)
			false:
				if Rhythm.audio_stream_player.playing:
					Rhythm.audio_stream_player.stop()
					Rhythm.running = true
