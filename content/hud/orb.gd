extends Sprite2D
class_name WeaponOrb

const FLOAT_AMPLITUDE: float = 2.0
const FLOAT_TIME_SCALE: float = 2.0

const STATE_INTERVAL: float = 0.05
var last_shoot: float = -10000.0
var shoot_wobble: float = 2.0

var visual_state: int = 0:
	set(new):
		visual_state = new
		material.set_shader_parameter("flash_state", new)

var wobble_velocity: float = 0.0
var wobble_amplitude_scale: float = 2.0
var wobble_damping: float = 0.99

func _process(delta: float) -> void:
	position.y = sin(Time.get_ticks_msec() / 1000.0 * FLOAT_TIME_SCALE) * FLOAT_AMPLITUDE
	position.y += sin(Time.get_ticks_msec() / 1000.0 * wobble_velocity) * wobble_velocity * wobble_amplitude_scale
	
	wobble_velocity *= pow(1.0 - wobble_damping, delta)
	if wobble_velocity < 0.001: wobble_velocity = 0.0
	
	if visual_state != 0:
		if time_since_last_shoot() < STATE_INTERVAL * abs(visual_state) + 1 and time_since_last_shoot() > STATE_INTERVAL * abs(visual_state):
			visual_state = int(move_toward(visual_state, 0, 1))

func get_time() -> float: return Time.get_ticks_msec() / 1000.0

func time_since_last_shoot() -> float:
	return get_time() - last_shoot

func fail():
	wobble_velocity = shoot_wobble
	last_shoot = get_time()
	visual_state = -2

func shoot():
	wobble_velocity = shoot_wobble
	last_shoot = get_time()
	visual_state = 2
