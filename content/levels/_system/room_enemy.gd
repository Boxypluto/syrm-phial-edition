extends RoomEntity
class_name RoomEnemy

@export var dropped_weapon: PackedScene = null

var is_defeated: bool = false

signal defeated

func i_am_an_enemy() -> void:
	pass

func do_death():
	if dropped_weapon != null:
		var weapon: Pickupable = dropped_weapon.instantiate()
		Game.add_spawned(weapon)
		weapon.global_position = self.global_position + Vector3.UP * 1.0
		weapon.set_axis_velocity(Vector3(0, .0, 0))
		weapon.angular_velocity = Vector3.ONE * 5.0
	is_defeated = true
	visible = false
	defeated.emit()
	queue_free()
