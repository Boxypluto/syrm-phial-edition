extends Sprite2D
class_name WeaponOrb

const FLOAT_AMPLITUDE: float = 2.0
const FLOAT_TIME_SCALE: float = 2.0

const STATE_INTERVAL: float = 0.05
var last_shoot: float = -10000.0

var visual_state: int = 0:
	set(new):
		visual_state = new
		material.set_shader_parameter("flash_state", new)

func _process(delta: float) -> void:
	position.y = sin(Time.get_ticks_msec() / 1000.0 * FLOAT_TIME_SCALE) * FLOAT_AMPLITUDE
	
	if time_since_last_shoot() < STATE_INTERVAL:
		visual_state = 2
	elif time_since_last_shoot() < STATE_INTERVAL * 2:
		visual_state = 1
	elif time_since_last_shoot() < STATE_INTERVAL * 3:
		visual_state = 2
	else:
		visual_state = 0

func get_time() -> float: return Time.get_ticks_msec() / 1000.0

func time_since_last_shoot() -> float:
	return get_time() - last_shoot

func shoot():
	last_shoot = get_time()
	visual_state = 2
