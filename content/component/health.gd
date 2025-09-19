extends Node
class_name Health

@export var current_health: float = 10.0

func damage(damage_amount: float):
	current_health -= damage_amount
