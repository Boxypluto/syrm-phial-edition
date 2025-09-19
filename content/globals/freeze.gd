extends Node

var last_freeze_start: float = 0.0
var last_freeze_time: float = 0.0
var is_frozen: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func freeze(time: float):
	is_frozen = true
	last_freeze_start = Time.get_ticks_msec() / 1000.0
	last_freeze_time = time
	Game.GAME.process_mode = Node.PROCESS_MODE_DISABLED

func timer_finished(timer_length: float, start_time: float):
	return Time.get_ticks_msec() / 1000.0 - start_time >= timer_length

func _physics_process(delta: float) -> void:
	if is_frozen and timer_finished(last_freeze_time, last_freeze_start):
		is_frozen = false
		Game.GAME.process_mode = Node.PROCESS_MODE_INHERIT
