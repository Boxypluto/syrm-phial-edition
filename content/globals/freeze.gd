extends Node

var last_freeze_start: float = 0.0
var last_freeze_time: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func freeze(time: float):
	last_freeze_start = Time.get_ticks_msec() / 1000.0
	last_freeze_time = time
	get_tree().paused = true

func timer_finished(timer_length: float, start_time: float):
	return Time.get_ticks_msec() / 1000.0 - start_time >= timer_length

func _physics_process(delta: float) -> void:
	if get_tree().paused and timer_finished(last_freeze_time, last_freeze_start):
		get_tree().paused = false
