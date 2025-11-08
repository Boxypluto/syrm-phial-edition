extends Damager
class_name TwirlDamage

@onready var dps: Timer = $DPS
@onready var collision: CollisionShape3D = $Collision

var active: bool = false:
	set(new):
		active = new
		if dps == null: return
		if active:
			dps.start()
			collision.disabled = false
		else:
			collision.disabled = true
			if not dps.is_stopped():
				dps.stop()

func on_do_damage() -> void:
	collision.disabled = false
	await get_tree().create_timer(dps.wait_time / 2.0).timeout
	collision.disabled = true
