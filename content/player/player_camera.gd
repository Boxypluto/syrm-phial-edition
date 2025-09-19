extends Camera3D
class_name MainCamera

@onready var SHOOT_POINT_ORB: Marker3D = $OrbShootPoint

var shake_timer: Timer = Timer.new()
var shake_interval: Timer = Timer.new()

const SHAKE_INTERVAL_TIME: float = 0.05
var shake_amount: float = 0.0

func _ready() -> void:
	shake_timer.one_shot = true
	shake_interval.one_shot = true
	
	add_child(shake_timer)
	add_child(shake_interval)
	
	shake_timer.timeout.connect(stop_shake)
	shake_interval.timeout.connect(interval_shake)

func shake(time: float, amount: float):
	shake_amount = amount
	shake_timer.start(time)
	shake_interval.start(SHAKE_INTERVAL_TIME)

func interval_shake():
	if shake_timer.is_stopped(): return
	
	h_offset = randf_range(-shake_amount, shake_amount)
	v_offset = randf_range(-shake_amount, shake_amount)
	
	shake_interval.start(SHAKE_INTERVAL_TIME)

func stop_shake():
	h_offset = 0.0
	v_offset = 0.0
