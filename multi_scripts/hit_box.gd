extends Area3D
class_name HitBox

signal hit(damage: DamageInfo)

func on_hit(damage: DamageInfo):
	hit.emit(damage)
