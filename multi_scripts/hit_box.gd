extends Area3D
class_name HitBox

signal hit(damage: DamageInfo)

var enabled: bool = true:
	set(new):
		enabled = new
		process_mode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED
var disabled: bool:
	set(new):
		enabled = not new
	get():
		return not enabled
var is_alive: bool = true

func on_hit(damage: DamageInfo):
	if disabled: return
	hit.emit(damage)
