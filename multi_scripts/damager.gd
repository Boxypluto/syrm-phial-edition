extends Area3D
class_name Damager

@export var damage: DamageInfo

func _ready() -> void:
	area_entered.connect(on_collided)

func on_collided(area: Area3D):
	if area is HitBox:
		area.on_hit(damage)
