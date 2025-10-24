@abstract
extends Node
class_name WeaponState

func weapon_input() -> void:
	pass

func attack_action() -> void:
	pass

func damage_hitbox(possible_hitbox: Node3D, damage: DamageInfo) -> bool:
	if possible_hitbox is not HitBox:
		return false
	possible_hitbox = possible_hitbox as HitBox
	possible_hitbox.hit.emit(damage)
	return true
