extends Camera3D
class_name MainCamera

@onready var SHOOT_POINT_ORB: Marker3D = $OrbShootPoint

var shake_timer: Timer = Timer.new()
var shake_interval: Timer = Timer.new()

const SHAKE_INTERVAL_TIME: float = 0.05
var shake_amount: float = 0.0
var rotation_goal: float = 0.0
var base_fov: float = 75
var fov_goal: float = 0.0
var wobble_offset: float = 0.0
var shake_offset: Vector2

func _ready() -> void:
	shake_timer.one_shot = true
	shake_interval.one_shot = true
	
	add_child(shake_timer)
	add_child(shake_interval)
	
	shake_timer.timeout.connect(stop_shake)
	shake_interval.timeout.connect(interval_shake)

func _process(delta: float) -> void:
	rotation.z = rotate_toward(rotation.z, rotation_goal, delta * 10.0)
	fov = move_toward(fov, base_fov + fov_goal, delta * 100.0)
	
	wobble_offset = sin(Time.get_ticks_msec() / 30.0) / 50
	
	h_offset = shake_offset.x
	v_offset = shake_offset.y + (wobble_offset if Vector.flatten(Game.PLAYER.velocity) != Vector2.ZERO else 0)

func shake(time: float, amount: float):
	shake_amount = amount
	shake_timer.start(time)
	shake_interval.start(SHAKE_INTERVAL_TIME)

func interval_shake():
	if shake_timer.is_stopped(): return
	
	shake_offset.x = randf_range(-shake_amount, shake_amount)
	shake_offset.y = randf_range(-shake_amount, shake_amount)
	
	shake_interval.start(SHAKE_INTERVAL_TIME)

func stop_shake():
	shake_offset.x = 0.0
	shake_offset.y = 0.0
