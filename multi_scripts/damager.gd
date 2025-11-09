extends Area3D
class_name Damager

@export var damage: DamageInfo

signal did_damage(other: HitBox)

func _ready() -> void:
	area_entered.connect(on_collided)

func on_collided(area: Area3D):
	if area is HitBox:
		did_damage.emit(area)
		area.on_hit(damage)
