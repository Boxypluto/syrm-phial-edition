@abstract
extends Node
class_name WeaponState

const EMEMY_HURT_EFFECT = preload("uid://bpe1qgvrea1jx")

func weapon_input() -> void:
	pass

func attack_action() -> void:
	pass

func damage_hitbox(possible_hitbox: Node3D, damage: DamageInfo) -> bool:
	if possible_hitbox is not HitBox:
		return false
	if possible_hitbox.is_alive:
		var effect: Node3D = EMEMY_HURT_EFFECT.instantiate()
		Game.add_spawned(effect)
		effect.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
		effect.global_position = possible_hitbox.global_position + Vector3(0, 1, 0)
		effect.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
	possible_hitbox = possible_hitbox as HitBox
	possible_hitbox.hit.emit(damage)
	return true
