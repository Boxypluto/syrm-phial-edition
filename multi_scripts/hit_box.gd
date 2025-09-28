extends Area3D
class_name HitBox

signal hit(damage: float)

func _init() -> void:
	area_entered.connect(on_hit_by_area)
	body_entered.connect(on_hit_by_body)
	
	area_entered.connect(on_hit)
	body_entered.connect(on_hit)
	
	area_entered.connect(hit.emit)
	body_entered.connect(hit.emit)

func on_hit_by_area(other: Area3D) -> void:
	pass

func on_hit_by_body(other: Node3D) -> void:
	pass

func on_hit(other: Node3D) -> void:
	pass

func on_hurt(damage: float):
	hit.emit(damage)
