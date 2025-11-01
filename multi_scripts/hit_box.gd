extends Area3D
class_name HitBox

signal hit(damage: DamageInfo)

var is_alive: bool = true

func on_hit(damage: DamageInfo):
	hit.emit(damage)
